# Place app-wide constants here
# Do not put access keys from 3rd party services here (use env variables)
EXAMPLE_TEXT = "Lorem ipsum dolor sit amet, consectetur adipiscing elit.
                Etiam ut sapien sed urna rutrum dapibus. Suspendisse vel
                ante sed felis bibendum convallis in vel orci. Ut at
                tellus porttitor neque cras amet.".squish.freeze

NOT_FOUND = ActionController::RoutingError.new('Not Found')
TIMEZONE  = "Central Time (US & Canada)".freeze