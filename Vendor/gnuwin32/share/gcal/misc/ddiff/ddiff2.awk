#  $Id: ddiff2.awk 0.05 2000/03/20 00:00:05 tom Exp $
#
#  ddiff2.awk:  Creates a Gcal location resource file.
#
#  Any but default configuration could confuse this script.
#  It comes along with a UN*X script `ddiff' and a DOS batch `ddiff.bat'
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
  #
  # Define the default return values of this process.
  #
  EXIT_SUCCESS = 0
  EXIT_FATAL   = 2
  #
  # Get possibly given command line arguments.
  #
  for (i=1 ; i < ARGC ; i++)
   {
     if (substr(ARGV[i], 1, 1) == "-")
      {
        if (substr(ARGV[i], 2, 1) == "a")
          a = substr(ARGV[i], 3)
        else
          exit EXIT_FATAL
      }
     else
       break
     delete ARGV[i]
   }
  #
  # Set the default value of some variables.
  #
  ndiff = 0
  dndiff = 0
  first_run = 0
  full_time = 0
  #
  # Create the file header of Gcal location resource file.
  #
  printf "; %s, day/night lengths and differences for Gcal-2.20 or newer\n;\n", a
}
#
# Main block.
#
{
  if (length($3) > 7)
    full_time = 1
  dh = substr($3, 1, 2)
  dm = substr($3, 4, 2)
  dt = dh * 3600 + dm * 60
  if (full_time == 1)
    dt += substr($3, 7, 6)
  if (first_run == 0)
   {
     first_run = 1
     cc = substr($2, 1, 2)
     location = substr($2, 4)
     printf "; Location:      %s, %s\n", location, cc
     printf "; Co-ordinate:   %s\n", $5
     printf "; Created:       %s, %s\n", $6, $7
     printf "; \\\n"
     if (full_time == 1)
      {
        printf "YYYYMMDD day=d          night=n        location       dnDiff         delta          DdMAX          DdMIN\\\n"
        printf "-----------------------------------------------------------------------------------------------------------------\n"
      }
     else
      {
        printf "YYYYMMDD day=d   night=n location       dnDiff  delta  DdMAX   DdMIN\\\n"
        printf "----------------------------------------------------------------------\n"
      }
     ddiff = dt
   }
  nh = substr($4, 1, 2)
  nm = substr($4, 4, 2)
  nt = nh * 3600 + nm * 60
  if (full_time == 1)
    nt += substr($4, 7, 6)
  if (ndiff == 0)
    ndiff = nt
  diff = dt - nt
  if (dndiff == 0)
    dndiff = diff
  delta = diff - dndiff
  x = dmax - dt
  ddmaxh = int(x) / 3600
  if (ddmaxh < 0)
    ddmaxh = -ddmaxh
  ddmaxm = ((int(x) % 3600) + (x - int(x))) / 60
  if (ddmaxm < 0)
    ddmaxm = -ddmaxm
  x = dt - dmin
  ddminh = int(x) / 3600
  if (ddminh < 0)
    ddminh = -ddminh
  ddminm = ((int(x) % 3600) + (x - int(x))) / 60
  if (ddminm < 0)
    ddminm = -ddminm
  if (full_time == 1)
   {
     if (delta < 0)
      {
        delta_sign = "-"
        delta = -delta
      }
     else
       delta_sign = "+"
     delta_mins = ((int(delta) % 3600) + (delta - int(delta))) / 60
     ddmaxs = (ddmaxm - int(ddmaxm)) * 60
     ddmins = (ddminm - int(ddminm)) * 60
     if (diff < 0)
      {
        diff_mins = ((int(-diff) % 3600) + (-diff - int(-diff))) / 60
        printf "%s %s %s %-14s~-%02dh%02d'%06.3f\" %s%02dh%02d'%06.3f\" -%02dh%02d'%06.3f\" +%02dh%02d'%06.3f\"\n", \
          substr($1, 1, 8), $3, $4, substr(location, 1, 14),
          -diff/3600, diff_mins, (diff_mins-int(diff_mins))*60,
          delta_sign, delta/3600, delta_mins, (delta_mins-int(delta_mins))*60,
          ddmaxh, ddmaxm, ddmaxs, ddminh, ddminm, ddmins
      }
     else
      {
        diff_mins = ((int(diff) % 3600) + (diff - int(diff))) / 60
        printf "%s %s %s %-14s~+%02dh%02d'%06.3f\" %s%02dh%02d'%06.3f\" -%02dh%02d'%06.3f\" +%02dh%02d'%06.3f\"\n", \
          substr($1, 1, 8), $3, $4, substr(location, 1, 14),
          diff/3600, diff_mins, (diff_mins-int(diff_mins))*60,
          delta_sign, delta/3600, delta_mins, (delta_mins-int(delta_mins))*60,
          ddmaxh, ddmaxm, ddmaxs, ddminh, ddminm, ddmins
      }
   }
  else
   {
     if (diff < 0)
       printf "%s %s %s %-14s -%02dh%02d' %+05d' -%02dh%02d' +%02dh%02d'\n", \
         substr($1, 1, 8), $3, $4, substr(location, 1, 14),
         -diff/3600, (-diff%3600)/60, delta/60, ddmaxh, ddmaxm, ddminh, ddminm
     else
       printf "%s %s %s %-14s +%02dh%02d' %+05d' -%02dh%02d' +%02dh%02d'\n", \
         substr($1, 1, 8), $3, $4, substr(location, 1, 14),
         diff/3600, (diff%3600)/60, delta/60, ddmaxh, ddmaxm, ddminh, ddminm
   }
  ddiff = dt
  ndiff = nt
  dndiff = diff
}
END {
  exit EXIT_SUCCESS
}
