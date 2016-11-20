#  $Id: wlocdrv1.awk 0.07 2000/03/23 00:00:07 tom Exp $
#
#  wlocdrv1.awk:  Generates the `wloc' script text necessary to create
#                   all location files which contain air line distances
#                   and course angles between several geographic locations
#                   around the world, by processing the ZONE file `zone.tab'.
#
#  Any but default configuration could confuse this script.
#  It comes along with a UN*X script `wlocdrv' and a DOS batch `wlocdrv.bat'
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
          shell = substr(ARGV[i], 3)
        else
          if (substr(ARGV[i], 2, 1) == "b")
            gcalresource = substr(ARGV[i], 3)
          else
            if (substr(ARGV[i], 2, 1) == "c")
              gcalprogram = substr(ARGV[i], 3)
            else
              if (substr(ARGV[i], 2, 1) == "d")
                precise = substr(ARGV[i], 3)
              else
                exit EXIT_FATAL
      }
     else
       break
     delete ARGV[i]
   }
  if (shell == 1)
   {
     rem = "#"
     header = "#! /bin/sh"
   }
  else
   {
     rem = "::"
     header = "@echo off"
   }
  printf "%s\n%s\n", header, rem
  printf "%s Air line distances between geographical locations for Gcal-2.20 or newer\n", rem
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
         {
           loc = loc "\\"
           if (a == 0)
             loc = loc "\\"
         }
        loc = loc substr(location, i, 1)
      }
     cc = $1
     printf "%s\n%s Location %s, %s\n%s\n", rem, rem, location, cc, rem
     outname = ""
     len = length(cc)
     for (i=1 ; i <= len ; i++)
       outname = outname tolower(substr(cc, i, 1))
     outname = outname "-"
     len = length(loc)
     for (i=1 ; i <= len ; i++)
      {
        chr = tolower(substr(loc, i, 1))
        if (chr == "\\")
         {
           outname = outname "_"
           if (shell == 1)
             i++
         }
        else
          outname = outname chr
      }
     if (shell == 1)
      {
        printf "echo \"%s: creating the air line distance file \\`%s', please wait...\"\n", \
          gcalprogram, outname
        printf "%s %s -QUx -Hno -f%s -r\\$a=%s-%s:\\$b=%s > %s\n", \
          gcalprogram, precise, gcalresource, cc, loc, $2, outname
      }
     else
      {
        outname = substr(outname, 1, 8)
        printf "echo %s: creating the air line distance file `%s', please wait...\n", \
          gcalprogram, outname
        printf "%s %s -QUx -Hno -f%s -r$a=%s-%s:$b=%s> %s\n", \
          gcalprogram, precise, gcalresource, cc, loc, $2, outname
      }
   }
}
END {
  exit EXIT_SUCCESS
}
