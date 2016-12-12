module DateTimeParser
  # converts "MM/DD/YYYY" and "MM/DD/YYYY HH:MM XM" formats
  def self.string_to_datetime string
    # reorganize datestring from mm/dd/yyyy to dd/mm/yyyy format for parse method
    string = string.split '/'
    string = [string.second, string.first, string.third].join '/'
    string.in_time_zone TIMEZONE
  end

  def self.datetime_to_string datetime, date_format=false
    dformat = date_format ? DATE_STRFTIME : DATETIME_STRFTIME

    datetime.in_time_zone(TIMEZONE).strftime(dformat)
  end
end