include cef_import #, times

type
  cef_time* = object
    year: int          # Four digit year "2007"
    month: int         # 1-based month (values 1 = January, etc.)
    day_of_week: int   # 0-based day of week (0 = Sunday, etc.)
    day_of_month: int  # 1-based day of month (1-31)
    hour: int          # Hour within the current day (0-23)
    minute: int        # Minute within the current hour (0-59)
    second: int        # Second within the current minute (0-59 plus leap
                   #   seconds which may take it up to 60).
    millisecond: int   # Milliseconds within the current second (0-999)

# Converts cef_time_t to/from time_t. Returns true (1) on success and false (0)
# on failure.
#proc cef_time_to_timet*(ctime: ptr cef_time, time: Time): int {.cef_import.}
#proc cef_time_from_timet*(time: Time, ctime: ptr cef_time): int {.cef_import.}


# Converts cef_time_t to/from a double which is the number of seconds since
# epoch (Jan 1, 1970). Webkit uses this format to represent time. A value of 0
# means "not initialized". Returns true (1) on success and false (0) on
# failure.
proc cef_time_to_doublet*(ctime: ptr cef_time, time: var float64): int {.cef_import.}
proc cef_time_from_doublet*(time: float64, ctime: ptr cef_time): int {.cef_import.}

# Retrieve the current system time.
proc cef_time_now*(ctime: ptr cef_time): int {.cef_import.}

# Retrieve the delta in milliseconds between two time values.
proc cef_time_delta*(ctime1, ctime2: ptr cef_time, delta: var uint64): int {.cef_import.}