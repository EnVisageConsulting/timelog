module DateTimeParser
  # converts "MM/DD/YYYY" and "MM/DD/YYYY HH:MM XM" formats
  def self.string_to_datetime string
    # reorganize datestring from mm/dd/yyyy to dd/mm/yyyy format for parse method
    string = string.split '/'
    string = [string.second, string.first, string.third].join '/'
    string.in_time_zone TIMEZONE
  end
end