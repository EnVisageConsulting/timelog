# Place app-wide constants here
# Do not put access keys from 3rd party services here (use env variables)
EXAMPLE_TEXT = "Lorem ipsum dolor sit amet, consectetur adipiscing elit.
                Etiam ut sapien sed urna rutrum dapibus. Suspendisse vel
                ante sed felis bibendum convallis in vel orci. Ut at
                tellus porttitor neque cras amet.".squish.freeze

TIMEZONE  = "Central Time (US & Canada)".freeze


TIME_STRFTIME     = "%I:%M %p".freeze
DATE_STRFTIME     = "%m/%d/%Y".freeze
DATETIME_STRFTIME = "#{DATE_STRFTIME} #{TIME_STRFTIME}".freeze
DATE_PATTERN      = /[0-1]?\d\/[0-3]?\d\/\d{4}/.freeze
DATETIME_PATTERN  = /[0-1]?\d\/[0-3]?\d\/\d{4}\s\d?\d:[0-5][0-9]\s(p|a)m/i.freeze
UTC_DATE_STRFTIME = "%Y%m%d".freeze