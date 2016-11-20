#  $Id: cal2gcal.awk 0.12 2000/06/14 00:01:02 tom Exp $
#
#  cal2gcal.awk:  Very simple, slow and silly AWK script for converting
#                   "BSD-calendar" appointments into the `gcal' format.
#
#
#  Copyright (c) 1995, 1996, 2000  Thomas Esken      <esken@gmx.net>
#                                  Im Hagenfeld 84
#                                  D-48147 M"unster
#                                  GERMANY
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
  # Define the field separator used (blank actually).
  #
  FS = " "
  #
  # Define the length of the text displayed on a line.
  #   This is a minimum value suggesting where the first position of a
  #   break can take place.  If this happens within a word, the break
  #   is done at its end.
  #   Set `linebreak' to 0 if you don't want to break the text explicitly
  #   (this is the same mode which was done by former versions of this script).
  #
  linebreak = 0
  #
  # The length of an ordinary date part of a gcal resource file line.
  #
  dpartlen = 8
  #
  # The newline character of a gcal text line.
  #
  gcalnl = "~"
  #
  # Print some leading comment text.
  #
  print "; cal2gcal.awk output for Gcal-2.20 or newer"
  print ";"
  print "; Absolutely NO warrenty!"
  print ";"
  print ";"
  #
  # Pre-initialize the constructed line.
  #
  line = ""
  textpart = ""
}
#
# Main block.
#
{
   #
   # Construct the line.
   #
   if (substr($1, 3, 1) == "/")
    {
      #
      # If line is completed just print it.
      #
      if (line != "")
       {
         if (linebreak < 1)
           print line
         else
          {
            #
            #  Manage possible breaks in the text part of appointment.
            #
            tpart = substr(line, dpartlen+2)
            len_tpart = length(tpart)
            if (len_tpart > linebreak)
             {
               k = 0
               textpart = ""
               for (i=1 ; i <= len_tpart ; i += (linebreak+k))
                {
                  textpart = textpart substr(tpart, i, linebreak-1)
                  j = 0
                  k = 0
                  while (substr(tpart, linebreak+i+j-1, 1) !~ /[ \t]/)
                   {
                     textpart = textpart substr(tpart, linebreak+i+j-1, 1)
                     j++
                     if (linebreak + i + j - 1 > len_tpart)
                       break
                   }
                  k += j
                  textpart = textpart gcalnl
                }
             }
            else
              textpart = tpart
            i = length(textpart)
            if (substr(textpart, i, 1) == gcalnl)
              print substr(line, 1, dpartlen+1) substr(textpart, 1, i-1)
            else
              print substr(line, 1, dpartlen+1) textpart
          }
         line = ""
         textpart = ""
       }
      #
      # Strip leading whitespace characters in text part of appointment.
      #
      i = length($1) + 1
      while (substr($0, i, 1) ~ /[ \t]/)
        i++
      line = "0000" substr($1, 1, 2) substr($1, 4, 2) " " substr($0, i)
    }
   else
    {
      #
      # Strip leading whitespace characters of continued
      #   text part of appointment.
      #
      i = 1
      while (substr($0, i, 1) ~ /[ \t]/)
        i++
      line = line " " substr($0, i)
    }
}
END {
  #
  # Manage last line of file.
  #
  if (linebreak < 1)
    print line
  else
   {
     #
     #  Manage possible breaks in the text part of appointment.
     #
     tpart = substr(line, dpartlen+2)
     len_tpart = length(tpart)
     if (len_tpart > linebreak)
      {
        k = 0
        textpart = ""
        for (i=1 ; i <= len_tpart ; i += (linebreak+k))
         {
           textpart = textpart substr(tpart, i, linebreak-1)
           j = 0
           k = 0
           while (substr(tpart, linebreak+i+j-1, 1) !~ /[ \t]/)
            {
              textpart = textpart substr(tpart, linebreak+i+j-1, 1)
              j++
              if (linebreak + i + j - 1 > len_tpart)
                break
            }
           k += j
           textpart = textpart gcalnl
         }
      }
     else
       textpart = tpart
     i = length(textpart)
     if (substr(textpart, i, 1) == gcalnl)
       print substr(line, 1, dpartlen+1) substr(textpart, 1, i-1)
     else
       print substr(line, 1, dpartlen+1) textpart
   }
}
