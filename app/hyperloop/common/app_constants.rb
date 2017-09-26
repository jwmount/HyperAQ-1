module AppConstants

  # useful time constants
  SECONDS_PER_HOUR = 60*60
  SECONDS_PER_DAY = 24*SECONDS_PER_HOUR
  SECONDS_PER_WEEK = SECONDS_PER_DAY * 7
  #
  # number of days old a history entry can be before pruning
  #
  PRUNE_THRESHOLD = 14 * SECONDS_PER_DAY
  #
  # on/off code for GPIO.
  #
  OPEN = 1
  CLOSE = 0

  # strftime formatting cheat sheet
  #  %a - abbreviated weekday name ('Sun')
  #  %w - weekday (0..6)
  #  %b - abbreviated month name ('Jan')
  #  %-d  day of month, no-padding (1..31)
  #  %l - Hour of the day, 12-hour clock, blank-padded (1..12)
  #  %M - Minute of the hour (0..59)
  #  %H - Hour of the day (0..23)
  #  %P - Meridian indicator, lowercase ('am' or 'pm')
  #

  # format string for crontab times: minute, hour, * (month), * (monthday), weekday

  CRONTAB_STRFTIME = "%02M %02H * * %w"
  CRONTAB_STRFTIME = "%02M %02H * * %w"
  # 54 9 * 1 0

  TIME_INPUT_STRFTIME = "%a %-d %b %l:%M %P"
  #  Sun 28 Jan 9:54 am

end