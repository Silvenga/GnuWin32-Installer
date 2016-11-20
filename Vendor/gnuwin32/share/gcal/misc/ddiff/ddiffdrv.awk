#  $Id: ddiffdrv.awk 0.05 2000/01/12 00:00:05 tom Exp $
#
#  ddiffdrv.awk:  Processes the ZONE file `zone.tab' and creates
#                   Gcal location response files.
#
#  Any but default configuration could confuse this script.
#  It comes along with a UN*X script `ddiffdrv' and a DOS batch `ddiffdrv.bat'
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
          if (substr(ARGV[i], 2, 1) == "b")
            b = substr(ARGV[i], 3)
          else
            if (substr(ARGV[i], 2, 1) == "c")
              c = substr(ARGV[i], 3)
            else
              exit EXIT_FATAL
      }
     else
       break
     delete ARGV[i]
   }
  printf "; %s, location names and coordinates for Gcal-2.20 or newer\n;\n", b
  printf "; The line template.\n;\n"
  if (a == 0)
    printf "$x=0 %s: Gcal location response file `$<1l*l' created...%%!echo -r'\\$c=$c:\\$l=$l' > $<1l*l\n", c
  else
    printf "$x=0 %s: Gcal location response file `$<8l#l' created...%%!echo -r\\$c=$c:\\$l=$l> $<8l#l\n", c
  printf ";\n; The locations.\n"
}
#
# Main block.
#
{
  if (substr($0, 1, 1) != "#" && $0 != "")
   {
     location = $3
     len = length(location)
     for (i=1 ; i <= len ; i++)
      {
        if (substr(location, i, 1) == "/")
         {
           len -= i
           location = substr(location, i+1, len)
           i = 1
         }
      }
     loc = ""
     len = length(location)
     for (i=1 ; i <= len ; i++)
      {
        if (substr(location, i, 1) == "_")
          loc = loc "\\"
        loc = loc substr(location, i, 1)
      }
     printf ";\n; Location %s, %s\n;\n$l=%s-%s\n$c=%s\n$x\n", \
       location, $1, $1, loc, $2
   }
}
END {
  exit EXIT_SUCCESS
}
