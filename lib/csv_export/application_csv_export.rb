require 'csv'

class ApplicationCsvExport
  include ActionView::Helpers
  include ApplicationHelper

  attr_accessor :row

  def rows
    @rows ||= []
  end

  # to render to file
  def render_to(path)
    FileUtils.mkdir_p(path.dirname) # make sure folder exists

    add_content
    generate_to(path)

    File.open(path)
  end

  # for direct render
  def render
    add_content
    generate
  end

  def self.content_type
    "text/csv"
  end

  protected

    def generate_to(path)
      # headers = self.class.get_headers

      CSV.open(path, 'wb') do |csv| #, headers: headers.present?
        # csv << headers if headers.present?
        rows.each { |row| csv << row }
      end
    end

    def generate
      # headers = self.class.get_headers

      CSV.generate() do |csv| #headers: headers.present?
        # csv << headers if headers.present?
        rows.each { |row| csv << row }
      end
    end

    def self.headers(*args)
      raise(ArgumentError, "must only use nil or string values for headers") unless args.all? { |arg| arg.is_a?(String) || arg.is?(NilClass) }
      @headers = args
    end

    def self.get_headers
      @headers
    end
end
