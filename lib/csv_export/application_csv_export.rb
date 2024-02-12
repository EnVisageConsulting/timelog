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
    "text/csv; charset=iso-8859-1; header=present"
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

      CSV.generate(nil, encoding: "utf-8") do |csv| #headers: headers.present?
        # csv << headers if headers.present?
        # raise csv.encoding.inspect
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

    def strip_invalid_chars(text)
      text.force_encoding("ASCII")

      text = text.scrub do |char|
        case char
        when "\xE2".force_encoding("ASCII")
          "E2"
        when "\x80".force_encoding("ASCII")
          "80"
        when "\x98".force_encoding("ASCII")
          "90"
        when "\x9C".force_encoding("ASCII")
          "9C"
        when "\x94".force_encoding("ASCII")
          "94"
        when "\x99".force_encoding("ASCII")
          "99"
        when "\x9D".force_encoding("ASCII")
          "9D"
        when "\x93".force_encoding("ASCII")
          "93"
        else
          "[?]"
        end
      end

      text = text.gsub("E28090", "'")
      text = text.gsub("E2809C", "\"")
      text = text.gsub("E28094", "--")
      text = text.gsub("E28099", "'")
      text = text.gsub("E2809D", '"')
      text = text.gsub("E28093", "--")

      text
    end
end
