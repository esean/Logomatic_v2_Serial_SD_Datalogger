Changes:
---------------------------
orig - as copied from SF website, no changes
0 - turned off LED3 (set P0.31 high) when unit is on, it now flashes when a measurement is taken
1 - write cfg to disk when starting capture, simplify write to SD functions/buffer access
2 - cleanup adc read code
3 - fixed bug in 2/ where data was not being written to sdcard
4 - added error_dbg_to_sdcard_fatal() so now any text can be written to sdcard as debug info
5 - fixed LOGx naming, error_dbg_... now queues data if file_is_open==0, added VERSION, Log_init defaults LOGCON to #def defaults with snprintf()
6 - small cleanups, sanity restored (NEED TO FORMAT SDCARD. ALWAYS WORK IN WINDOWS, MAC SCREWS UP MEMORY CARD!) dual-channel capture working, added photo resistor
7 - put uC to idle mode in mode_action to save power, each interrupt wakes it to see if something to do:w

8 - TODO:added RTC
    # TODO: turn on RTC and log times to files, or at least log the start time and sampling frequency
    # TODO: hw mod to lift pin 49 and wire to vbat so RTC remains running when off

