#  $Id: ct2gcal.awk 0.20 2000/06/14 00:02:00 tom Exp $
#
#  ct2gcal.awk:  Very simple, slow and silly AWK script for converting
#                  "[X]Calentool-2.3" appointments into the `gcal' format.
#
#
#  Copyright (c) 1994, 95, 1996, 2000  Thomas Esken      <esken@gmx.net>
#                                      Im Hagenfeld 84
#                                      D-48147 M"unster
#                                      GERMANY
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
  # Print some leading comment text
  #
  print "; ct2gcal.awk output for Gcal-2.20 or newer"
  print ";"
  print "; Absolutely NO warrenty!"
  print ";"
  print ";"
  #
  # Maximum length of a gcal year yyyy (actually 4 places), month `mm',
  #   day `dd' and `n' field.
  #
  ylen = 4
  mlen = 2
  dlen = 2
  nlen = 1
  #
  # Maximum lenght of a repeated text
  #   means a maximum number of repetitions of 999.
  #
  rlen = 3
  #
  # The newline character of a text part of a gcal resource file line.
  #
  gcalnl = "~"
  #
  # The quote character of a text part of a gcal resource file line.
  #
  gcalqt = "\\"
  #
  # The remark character of a text part of a gcal resource file line.
  #
  gcalremark = ";"
  #
  # The `text' of a typical calentool appointment starts in column 19.
  #
  ctcolumn = 19
  #
  # The remark character sequence of a calentool appointment line.
  #
  ctremark = "# "
  #
  # The character sequence which indicates an eternal date field
  #   of a calentool appointment line
  #
  cteternal = "**"
}
#
# Main block.
#
{
  #
  # Test if line is a comment.
  #
  if (substr($0, 1, 1) == substr(ctremark, 1, 1))
   {
     #
     # First comment char found, check whether line contains a "#include" statement.
     #
     len = length($0)
     if (len > 1)
       ch = substr($0, 2, 1)
     else
       ch = ""
     if (ch == substr(ctremark, 2, 1) || ch == "")
       print gcalremark $0
     else
       print $0
   }
  else
   {
     #
     # We better work with buffer of first three fields of the line
     #   (gawk-2.15.6 fails if we don't work in such way).
     #
     f1 = $1
     f2 = $2
     f3 = $3
     #
     # On conversion we must calculate with some displacement.
     #
     displ = 0
     #
     # No comment, so try to convert...
     #
     if ($0 != "")
      {
        #
        # Test whether line contains an explictit gcal newline character ~
        #   if it is found, quote it by the gcal quote character \
        #   i.e. generate character sequence \~ .
        #
        tmpstr = ""
        len = length($0)
        for (i=1; i <= len; i++)
         {
           ch = substr($0, i, 1)
           if (ch == gcalnl)
             tmpstr = tmpstr gcalqt
           tmpstr = tmpstr ch
         }
        $0 = tmpstr
        #
        # Add "inclusive_date" special text %iyyyy[mm[dd[n]]] (variable "idatetxt")
        #   in case a "... yyyy)" text fragment is found in line.
        #
        idatetxt = ""
        #
        if ($0 ~ /[0-9]+\)/)
         {
           #
           # Pattern found, so search all fields for information.
           #
           for (i=1; i <= NF; i++)
            {
              #
              # Extract the year number.
              #
              if ($i ~ /[0-9]+\)/)
               {
                 #
                 # "tmpstr = substr($i, /[0-9]+\)/)" fails on some AWK implementations,
                 #   so we must emulate that function by a loop  ;((
                 #
                 len = length($i)
                 for (j=1; j <= len; j++)
                  {
                    if (substr($i, j, 1) ~ /[0-9]/)
                      len = j
                  }
                 tmpstr = substr($i, len, length($i))
                 #
                 # Ok, lets go on...
                 #
                 len = length(tmpstr)
                 for (j=1; j <= len; j++)
                  {
                    ch = substr(tmpstr, j, 1)
                    if (ch ~ /[0-9]/)
                      idatetxt = idatetxt ch
                  }
                 #
                 # Add leading zeroes to the year until length(year)==ylen.
                 #
                 len = length(idatetxt)
                 if (len < ylen)
                  {
                    tmpstr = ""
                    len = ylen - len
                    for (j=1; j <= len; j++)
                      tmpstr = "0" tmpstr
                    idatetxt = tmpstr idatetxt
                  }
                 #
                 # Add month and day to "idatetxt".
                 #
                 if (f2 != cteternal)
                  {
                    idatetxt = idatetxt f2
                    if (f3 != cteternal)
                      idatetxt = idatetxt f3
                  }
                 #
                 # Cut "idatetxt" so it contains ylen+mlen+dlen characters maximum.
                 #
                 len = length(idatetxt)
                 if (len > ylen+mlen+dlen)
                   idatetxt = substr(idatetxt, len-(ylen+mlen+dlen-1), ylen+mlen+dlen)
               }
            }
         }
        #
        # Test if line contains a textual "[number]" field which
        #   indicates a date, that occurs at [number]'th weekday of month.
        #
        ntxt = ""
        loopto = NF
        #
        if (f3 !~ /[0-9]/)
         {
           if ($0 ~ /\[+[012345lL]+\]/)
            {
              for (i=1; i <= loopto; i++)
               {
                 if ($i ~ /\[+[012345lL]+\]/)
                  {
                    #
                    # Pattern found, so terminate loop.
                    #
                    loopto = i
                    #
                    # Extract the information.
                    #
                    # "tmpstr = substr($i, /\[+[012345lL]+\]/)" fails on some AWK implementations,
                    #   so we must emulate that function by a loop  ;((
                    #
                    len = length($i)
                    for (j=1; j <= len; j++)
                     {
                       if (substr($i, j, 1) ~ /[012345lL]/)
                         len = j
                     }
                    tmpstr = substr($i, len, length($i))
                    #
                    # Ok, lets go on...
                    #
                    len = length(tmpstr)
                    for (j=1; j <= len; j++)
                     {
                       ch = substr(tmpstr, j, 1)
                       if (ch ~ /[012345lL]/)
                         ntxt = ntxt ch
                     }
                    #
                    # Cut "ntxt" so it contains "nlen" characters maximum.
                    #
                    if (length(ntxt) > nlen)
                      ntxt = substr(ntxt, 1, nlen)
                    #
                    # Replace l|L(==last weekday in month) entry by a `9'.
                    #
                    if (ntxt ~ /[lL]/)
                      ntxt = "9"
                    #
                    # Append found number text to starting date special text.
                    #
                    if (idatetxt != "")
                      idatetxt = idatetxt ntxt
                    #
                    # Eliminate the found "[number]" field.
                    #
                    displ += (length($i) + 1)
                  }
               }
            }
         }
        #
        # Test if line contains a textual "<number>" field and eliminate it.
        #
        rtxt = ""
        loopto = NF
        #
        if ($0 ~ /<+[0-9]+>/)
         {
           for (i=1; i <= loopto; i++)
            {
              if ($i ~ /<+[0-9]+>/)
               {
                 #
                 # Pattern found, so terminate loop.
                 #
                 loopto = i
                 #
                 # Extract the information.
                 #
                 # "tmpstr = substr($i, /<+[0-9]+>/)" fails on some AWK implementations,
                 #   so we must emulate that function by a loop  ;((
                 #
                 len = length($i)
                 for (j=1; j <= len; j++)
                  {
                    if (substr($i, j, 1) ~ /[0-9]/)
                      len = j
                  }
                 tmpstr = substr($i, len, length($i))
                 #
                 # Ok, lets go on...
                 #
                 len = length(tmpstr)
                 for (j=1; j <= len; j++)
                  {
                    ch = substr(tmpstr, j, 1)
                    if (ch ~ /[0-9]/)
                      rtxt = rtxt ch
                  }
                 #
                 # Cut "rtxt" so it contains "rlen" characters maximum.
                 #
                 if (length(rtxt) > rlen)
                   rtxt = substr(rtxt, 1, rlen)
                 #
                 # Eliminate the information.
                 #
                 displ += (length($i) + 1)
               }
            }
         }
        #
        # Append "idatetxt" to line.
        #
        if (idatetxt == "")
          line = $0
        else
          line = $0 "%i" idatetxt
        if (f2 == cteternal)
          f2 = "00"
        if (f3 == cteternal)
          f3 = "00"
        #
        #  Manage possible breaks in the text part of appointment.
        #
        if (linebreak < 1)
          textpart = substr(line, ctcolumn+displ)
        else
         {
           tpart = substr(line, ctcolumn+displ)
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
             textpart = substr(textpart, 1, i-1)
         }
        if (rtxt != "")
         {
           #
           # If "rtxt" is given, produce the line "rtxt" times using a date variable.
           #
           print "a=" f2 f3 ntxt
           j = int(rtxt)
           #
           # Print line(s) only if repetition factor is 1 or more.
           #
           if (j > 0)
            {
              for (i=1; i <= j; i++)
               {
                 if (f1 != cteternal)
                   print "19" f1 "@a" i-1 " " textpart
                 else
                   print "0@a" i-1 " " textpart
               }
            }
         }
        else
         {
           #
           # Print the constructed line.
           #
           if (f1 != cteternal)
             print "19" f1 f2 f3 ntxt " " textpart
           else
             print "0000" f2 f3 ntxt " " textpart
         }
      }
   }
}
