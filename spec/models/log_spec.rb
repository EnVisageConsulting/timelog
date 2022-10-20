require 'rails_helper'

RSpec.describe Log, type: :model do
  describe "Associations" do
    it { is_expected.to belong_to :user }
    it { is_expected.to have_many :project_logs }
    it { is_expected.to have_many :projects}
  end

  describe "Validations" do
    let(:log) { FactoryBot.build(:log) }

    it { is_expected.to validate_presence_of :start_at }

    it "validates presence of :end_at if log is activated" do
      log.activated = false
      log.end_at    = nil

      expect(log.valid?).to be_truthy

      log.activated = true

      expect(log.valid?).to be_falsey
      expect(log.errors[:end_at]).to include "can't be blank"
    end

    it "validates presence of :project_logs association if log has" do
      log.end_at       = nil
      log.project_logs = []

      expect(log.valid?).to be_truthy

      log.end_at = Time.now

      expect(log.valid?).to be_falsey
      expect(log.errors[:project_logs]).to include "can't be blank"
    end

    describe "#start_at_comes_before_end_at" do
      let(:log) { FactoryBot.create :active_log }

      it "adds error if :end_at is prior to :start_at" do
        log.start_at = 1.minute.ago
        log.end_at   = log.start_at

        expect(log.valid?).to be_truthy

        log.end_at = log.start_at - 1.minute

        expect(log.valid?).to be_falsey
        expect(log.errors[:start_at]).to include "cannot come after the end date"
      end
    end

    describe "#end_at_in_the_past" do
      let(:log) { FactoryBot.create :active_log }

      it "adds error if :end_at is in the future" do
        log.end_at = Time.now

        expect(log.valid?).to be_truthy

        log.end_at = 5.minutes.from_now

        expect(log.valid?).to be_falsey
        expect(log.errors[:end_at]).to include "must be in the past"
      end
    end

    describe "#project_log_allocation" do
      it "adds error if total project log allocation is greater than 100%" do
        project_logs = FactoryBot.build_list :project_log, 2, total_allocation: 0.6 # times 2 (eqls 1.2)
        log.project_logs = project_logs

        expect(log.valid?).to be_falsey
        expect(log.errors[:project_logs]).to include "%s cannot add up to more than 100%"

        project_logs.each do |pl|
          pl.total_allocation = 0.4 # times 2 (eqls 1.0)
        end

        log.valid?
        expect(log.errors[:project_logs]).to be_blank
      end

      it "adds error if allocation doesn't match 100% and project has :end_at" do
        project_logs = FactoryBot.build_list :project_log, 2, total_allocation: 0.4 # times 2 (eqls 0.8)
        log.project_logs = project_logs
        log.end_at = Time.now

        expect(log.valid?).to be_falsey
        expect(log.errors[:project_logs]).to include "%s must add up to 100%"

        project_logs.each do |pl|
          pl.total_allocation = 0.5 # times 2 (eqls 1.0)
        end

        log.valid?
        expect(log.errors[:project_logs]).to be_blank
      end
    end

    describe "#max_date_range" do
      let(:log) { FactoryBot.create :active_log }

      it "adds error if logged range is greater than 8 hours" do
        log.end_at   = Time.now
        log.start_at = log.end_at - 8.hours

        expect(log.valid?).to be_truthy

        log.start_at = log.start_at - 5.minutes

        expect(log.valid?).to be_falsey
        expect(log.errors[:end_at]).to include "cannot be more than 8 hours from the start date"
      end
    end

    describe "#overlapping_user_logs" do
      let(:log) { FactoryBot.create :active_log }

      xit "adds error if the log's user has another log with overlapping daterange" do
        user         = log.user
        existing_log = FactoryBot.create :active_log, user: user, start_at: 2.hour.ago, end_at: 1.hour.ago

        log.start_at = existing_log.end_at - 30.minutes
        log.end_at   = existing_log.end_at + 30.minutes

        expect(log.valid?).to be_falsey

        log.start_at = existing_log.end_at + 1.minute

        expect(log.valid?).to be_truthy
      end
    end
  end

  describe "Callbacks" do
    describe "#set_activation" do
      let(:log) { FactoryBot.build :log, :with_project_log }

      it "sets :activated = true if end at is present on save" do
        expect(log.activated).to be_falsey
        expect {
          log.end_at = Time.now
          log.save && log.reload
        }.to change(log, :activated).to be_truthy
      end

      it "is triggered on save (not validations)" do
        log.end_at = Time.now
        log.save(validate: false) # don't run validations to skip validation callbacks
        log.reload
        expect(log.activated).to be_truthy
      end
    end

    describe "#set_project_log_hours" do
      let(:log) { FactoryBot.create :log }

      it "divides up hour allocation on child project log records (on validation)" do
        duration        = 8.hours
        project_log_one = FactoryBot.create :project_log, log: log, total_allocation: 0.25
        project_log_two = FactoryBot.create :project_log, log: log, total_allocation: 0.75

        log.project_logs = [project_log_one, project_log_two]
        log.end_at       = Time.now
        log.start_at     = log.end_at - duration

        expect(project_log_one.hours).to eql 0
        expect(project_log_two.hours).to eql 0

        log.valid?

        expect(project_log_one.hours).to eql Seconds.to_hours(project_log_one.total_allocation * duration)
        expect(project_log_two.hours).to eql Seconds.to_hours(project_log_two.total_allocation * duration)
      end
    end
  end

  describe "Setters & Getters" do
    let(:log) { FactoryBot.create :log }

    [:start_at, :end_at].each do |datetime_field|
      describe "##{datetime_field}=" do
        it "converts datetime strings (MM/DD/YYYY HH:MM XM) into datetime" do
          new_value    = 5.minutes.ago.beginning_of_minute.in_time_zone(TIMEZONE)
          string_value = new_value.strftime(DATETIME_STRFTIME) # MM/DD/YYYY HH:MM AM

          # value shouldn't already be set to new value
          expect(new_value.utc).to_not eql log.read_attribute(datetime_field).try(:utc)
          log.send("#{datetime_field}=", string_value)

          # value should now be set to new value
          expect(new_value.utc).to eql log.read_attribute(datetime_field).utc
        end
      end
    end
  end

  describe "Instance Methods" do
    let(:log) { FactoryBot.build :log }

    describe "#hours" do
      it "returns difference of date range in hours" do
        diff = 8.hours

        log.end_at   = Time.now
        log.start_at = log.end_at - diff
        # raise [log.hours.hours, diff].inspect

        expect(log.hours.to_i.hours).to eql diff
      end

      it "returns nil if :start_at or :end_at is blank" do
        log.start_at = Time.now
        log.end_at   = log.start_at
        expect(log.hours).to_not be_nil

        log.start_at = nil
        expect(log.hours).to be_nil

        log.start_at = log.end_at
        log.end_at   = nil
        expect(log.hours).to be_nil
      end

      it "returns nil if :start_at is greater than :start_at" do
        log.end_at   = Time.now
        log.start_at = log.end_at + 1.second

        expect(log.hours).to be_nil
      end
    end

    describe "#date" do
      it "returns log date in date string format" do
        value = Time.now.in_time_zone(TIMEZONE)

        log.start_at = value
        log.end_at   = value

        expect(log.date).to eql value.strftime(DATE_STRFTIME) # MM/DD/YYYY
      end

      it "returns date range (as string) if log spans multiple days" do
        middle   = Time.now.beginning_of_day.in_time_zone(TIMEZONE)
        start_at = middle + 5.minutes
        end_at   = middle - 5.minutes

        log.start_at = start_at
        log.end_at   = end_at

        expect(log.date).to eql "#{start_at.strftime(DATE_STRFTIME)} - #{end_at.strftime(DATE_STRFTIME)}"
      end

      it "returns nil if :start_at or :end_at are blank" do
        log.start_at = Time.now
        log.end_at   = log.start_at
        expect(log.date).to_not be_nil

        log.start_at = nil
        expect(log.date).to be_nil

        log.start_at = log.end_at
        log.end_at   = nil
        expect(log.date).to be_nil
      end
    end

    [:start_time, :end_time].each do |time_method|
      describe "##{time_method}" do
        it "returns nil if corresponding datetime field is nil" do
          log.send(time_method.to_s.gsub("time", "at="), nil) # set :end_at and :start_at

          expect(log.send(time_method)).to be_nil
        end

        it "returns time (with AM or PM) of corresponding datetime field" do
          value = Time.now.in_time_zone(TIMEZONE)
          log.send(time_method.to_s.gsub("time", "at="), value) # set :end_at and :start_at

          expect(log.send(time_method)).to eql value.strftime(TIME_STRFTIME)
        end
      end
    end
  end
end
