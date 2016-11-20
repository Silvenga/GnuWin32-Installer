#  $Id: daily.awk 0.05 2000/01/12 00:00:05 tom Exp $
#
#  daily.awk:  Processes Gcal resource file lines which are stored in the fixed
#                `DATE-PART HH1:MM1,HH2:MM2,%n,%t  FIXED-DATE-TEXT' format.
#                `HH1:MM1' is the time (HOUR:MINUTE) the fixed date takes place.
#                `HH2:MM2' is the time (HOUR:MINUTE) the fixed date is warned
#                in advance.  The valid range of HOUR is 00...23, and the
#                valid range of MINUTE is 00...59.  For example
#                  `0 08:15,00:30,%n,%t  Dentist'
#                creates a today's fixed date message of 30 minutes
#                starting at 07:45 until 08:15.
#
#  Any but default configuration could confuse this script.
#  It comes along with a UN*X script `daily' and a DOS batch `daily.bat'
#  which supports the correct usage.
#
#  It is *not* guaranteed that this script works for any other call than
#  the one given above but it could easily be modified and extended for
#  using other special modes of operation.
#
#  If you modify this script you have to rename the modified version.
#
#  If you make any improvements I would like to hear from you.
#  But I do not promise any support.
#
#  Copyright (c) 2000  Thomas Esken      <esken@uni-muenster.de>
#                      Im Hagenfeld 84
#                      D-48147 M"unster
#                      GERMANY
#
#  This software doesn't claim completeness, correctness or usability.
#  On principle I will not be liable for ANY damages or losses (implicit
#  or explicit), which result from using or handling my software.
#  If you use this software, you agree without any exception to this
#  agreement, which binds you LEGALLY !!
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the `GNU General Public License' as published by
#  the `Free Software Foundation'; either version 2, or (at your option)
#  any later version.
#
#  You should have received a copy of the `GNU General Public License'
#  along with this program; if not, write to the:
#
#    Free Software Foundation, Inc.
#    59 Temple Place - Suite 330
#    Boston, MA 02111-1307,  USA
#
#
BEGIN {
  #
  # Define the field separator used (BLANK actually).
  #
  FS = " "
  #
  # Define the character Gcal uses to separate the file name
  # and the line number of the fixed dates' origin.
  #
  GCAL_SEP = "#"
  #
  # Define some constant values.
  #
  HOURS_PER_DAY = 24
  MINUTES_PER_HOUR = 60
  MINUTES_PER_DAY = HOURS_PER_DAY * MINUTES_PER_HOUR
  #
  # Define the default return value of this process, which is EXIT_FAILURE.
  #
  EXIT_SUCCESS = 0
  EXIT_FAILURE = 1
  #
  exit_status = EXIT_FAILURE
}
#
# Main block.
#
{
  #
  # Skip all fields until the `HH1:MM1,HH2:MM2,%n,%t' timefield is detected.
  #
  len_field = 0
  timefield = 1
  if ($timefield ~ /[0-9]+\)/)
   {
     len_field += (length($timefield) + 1)
     timefield++
   }
  while (substr($timefield, 1, 1) !~ /[0-9]/ && $timefield != "")
   {
     len_field += (length($timefield) + 1)
     timefield++
   }
  if (substr($timefield, 1, 1) ~ /[0-9]/)
   {
     is_printed = 0
     #
     # Compute the current time `minute of day'.
     #
     actual = substr($timefield, 25, 2) * MINUTES_PER_HOUR + substr($timefield, 28, 2)
     #
     # Compute the events time `minute of day'.
     #
     event_hour = substr($timefield, 1, 2)
     event_minute = substr($timefield, 4, 2)
     event = event_hour * MINUTES_PER_HOUR + event_minute
     #
     # Compute the `number of minutes' the event must be displayed in advance.
     #
     advance = substr($timefield, 7, 2) * MINUTES_PER_HOUR + substr($timefield, 10, 2)
     #
     # Check whether the event is on tomorrow's day.
     #
     tomorrows_event = 0
     if (event-advance < 0)
       tomorrows_event = 1
     #
     # Pre-check whether the event must be displayed.
     #
     if (event-advance <= actual && (event >= actual || tomorrows_event == 1))
      {
        #
        # Store today's date text.
        #
        the_date = substr($timefield, 13, 11)
        #
        # Store currents time text.
        #
        the_time = substr($timefield, 25, 5)
        #
        # Detect the length of `timefield' field which is removed in output.
        #
        len_field += length($timefield) + 1
        #
        # Compute some constant values and assign some texts.
        #
        date_text_1 = ""
        date_text_2 = ""
        minutes_active = advance - (event - actual)
        if (tomorrows_event == 1)
         {
           #
           # Event was activated yesterday.
           #
           if (minutes_active - MINUTES_PER_DAY < 0)
             date_text_2 = "yesterday "
           else
            {
              #
              # Event will occur tomorrow.
              #
              minutes_active -= MINUTES_PER_DAY
              date_text_1 = " tomorrow"
            }
         }
        #
        # Check again whether the event must be displayed.
        #
        if (minutes_active <= advance)
         {
           is_printed = 1
           #
           # Compute some more constant values.
           #
           start_time = event - advance
           if (start_time < 0)
             start_time += MINUTES_PER_DAY
           #
           # And print the results in formatted manner.
           #
           if (NR > 1)
             printf "\n"
           if (timefield != 1)
            {
              if ($1 ~ /^\(.+[#][0-9]+\)$/)
               {
                 file_name = ""
                 file_line = ""
                 mode = 0
                 len = length($1) - 1
                 for (i=2; i <= len ; i++)
                  {
                    if (substr($1, i, 1) == GCAL_SEP)
                      mode++
                    else
                     {
                       if (mode == 0)
                         file_name = file_name substr($1, i, 1)
                       else
                         file_line = file_line substr($1, i, 1)
                     }
                  }
                 timefield--
                 printf "File: %s %d\n", file_name, file_line
               }
            }
           printf "Date: %s\nTime: %s\n", the_date, the_time
           remaining = event - actual
           if (remaining < 0)
             remaining = MINUTES_PER_DAY + (event - actual)
           printf "Appointment  at: %02d:%02d%s (in %d minutes)\n", \
             event_hour, event_minute, date_text_1, remaining
           printf "Activated since: %02d:%02d %s", \
             start_time / MINUTES_PER_HOUR, start_time % MINUTES_PER_HOUR, date_text_2
           if (advance > 0)
             printf "(%d of %d minutes active)", minutes_active, advance
           printf "\nMessage text: "
           if (timefield != 1)
             for (i=1; i < timefield; i++)
               printf "%s ", $i
           printf "%s\n", substr($0, len_field + 1)
           #
           # Set the return value of this process to EXIT_SUCCESS.
           #
           exit_status = EXIT_SUCCESS
         }
      }
   }
  else
    if (is_printed == 1)
      printf "              %s\n", $0
}
END {
  exit exit_status
}
