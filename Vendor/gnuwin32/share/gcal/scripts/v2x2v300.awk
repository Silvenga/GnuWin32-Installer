#  $Id: v2x2v300.awk 0.02 2000/05/30 00:00:02 tom Exp $
#
#  v2x2v300.awk:  Very simple, slow and silly AWK script for converting
#                   resource files of former Gcal versions, i.e. v2.20 and
#                   v2.40, into the style which is used by Gcal-3.00 or newer.
#                   This means, all `%?...' special texts which are obsolete
#                   now by reason Gcal offers the ability of defining an
#                   optional format statement, are converted into their
#                   according equivalents.
#
#
#  Copyright (c) 2000  Thomas Esken      <esken@gmx.net>
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
# Main block.
#
{
  if ($0 ~ /%/)
   {
     #
     # Build the line.
     #
     line = ""
     len = length($0)
     for (i=1; i <= len; i++)
      {
        ch = substr($0, i, 1)
        if (ch == "\\")
         {
           line = line ch
           if (i < len)
            {
              i++
              line = line substr($0, i, 1)
            }
         }
        else
         {
           if (ch == "%")
            {
              line = line ch
              if (i < len)
               {
                 action = 0
                 i++
                 ch = substr($0, i, 1)
                 #
                 # Name                                     Old ->  New
                 # ----                                     --- --  ---
                 # %complete weekday name                   %o  ->  %K
                 # %3-letter weekday name                   %O  ->  %>3#K
                 # %2-letter weekday name                   %K  ->  %>2#K
                 # %weekday number         (Mon=1...Sun=7)  %S  ->  %W
                 # %weekday number     ONS (Mon=1...Sun=7)  %I  ->  %>1&*W
                 # %weekday number     ONS (Mon=0...Sun=6)  %J  ->  %>1&*E
                 # %weekday number         (Sun=1...Sat=7)  %(  ->  %I
                 # %weekday number     ONS (Sun=1...Sat=7)  %<  ->  %>1&*I
                 # %weekday number         (Sun=0...Sat=6)  %)  ->  %J
                 # %weekday number     ONS (Sun=0...Sat=6)  %>  ->  %>1&*J
                 # %weekday number FLX     (Mon=1...Sun=7)  %[  ->  %S
                 # %weekday number FLX ONS (Mon=1...Sun=7)  %{  ->  %>1&*S
                 # %weekday number FLX     (Mon=0...Sun=6)  %]  ->  %T
                 # %weekday number FLX ONS (Mon=0...Sun=6)  %}  ->  %>1&*T
                 # %day of year number                      %+  ->  %N
                 # %day of year number +LZ                  %*  ->  %>03*N
                 # %day of year number     ONS              %&  ->  %>1&*N
                 # %day of year number +LZ ONS              %#  ->  %>03&*N
                 # %day number +LZ                          %N  ->  %>02*D
                 # %day number     ONS                      %s  ->  %>1&*D
                 # %day number +LZ ONS                      %u  ->  %>02&*D
                 # %complete month name                     %M  ->  %U
                 # %3-letter month name                     %T  ->  %>3#U
                 # %month number                            %U  ->  %M
                 # %month number +LZ                        %W  ->  %>02*M
                 # %month number     ONS                    %z  ->  %>1&*M
                 # %month number +LZ ONS                    %Z  ->  %>02&*M
                 # %complete year number +LZ                %=  ->  %>04*Y
                 # %birth age number                        %b  ->  %B
                 # %birth age number ONS                    %B  ->  %>1&*B
                 # %moonphase                               %-  ->  %O
                 # %moonphase +LZ                           %_  ->  %>03*O
                 # %moonphase text graphics image           %:  ->  %Z
                 # ----                                     --- -- ---
                 # Legend: +LZ == with leading zero{es},
                 #         FLX == flexible starting day of week (`-sN' option),
                 #         ONS == Ordinal Number Suffix.
                 #
                 if (ch == "o")
                  {
                    line = line "K"
                    action = 1
                  }
                 if (ch == "O")
                  {
                    line = line ">3#K"
                    action = 1
                  }
                 if (ch == "K")
                  {
                    line = line ">2#K"
                    action = 1
                  }
                 if (ch == "S")
                  {
                    line = line "W"
                    action = 1
                  }
                 if (ch == "I")
                  {
                    line = line ">1&*W"
                    action = 1
                  }
                 if (ch == "J")
                  {
                    line = line ">1&*E"
                    action = 1
                  }
                 if (ch == "(")
                  {
                    line = line "I"
                    action = 1
                  }
                 if (ch == "<")
                  {
                    line = line ">1&*I"
                    action = 1
                  }
                 if (ch == ")")
                  {
                    line = line "J"
                    action = 1
                  }
                 if (ch == ">")
                  {
                    line = line ">1&*J"
                    action = 1
                  }
                 if (ch == "[")
                  {
                    line = line "S"
                    action = 1
                  }
                 if (ch == "{")
                  {
                    line = line ">1&*S"
                    action = 1
                  }
                 if (ch == "]")
                  {
                    line = line "T"
                    action = 1
                  }
                 if (ch == "}")
                  {
                    line = line ">1&*T"
                    action = 1
                  }
                 if (ch == "+")
                  {
                    line = line "N"
                    action = 1
                  }
                 if (ch == "*")
                  {
                    line = line ">03*N"
                    action = 1
                  }
                 if (ch == "&")
                  {
                    line = line ">1&*N"
                    action = 1
                  }
                 if (ch == "#")
                  {
                    line = line ">03&*N"
                    action = 1
                  }
                 if (ch == "N")
                  {
                    line = line ">02*D"
                    action = 1
                  }
                 if (ch == "s")
                  {
                    line = line ">1&*D"
                    action = 1
                  }
                 if (ch == "u")
                  {
                    line = line ">02&*D"
                    action = 1
                  }
                 if (ch == "M")
                  {
                    line = line "U"
                    action = 1
                  }
                 if (ch == "T")
                  {
                    line = line ">3#U"
                    action = 1
                  }
                 if (ch == "U")
                  {
                    line = line "M"
                    action = 1
                  }
                 if (ch == "W")
                  {
                    line = line ">02*M"
                    action = 1
                  }
                 if (ch == "z")
                  {
                    line = line ">1&*M"
                    action = 1
                  }
                 if (ch == "Z")
                  {
                    line = line ">02&*M"
                    action = 1
                  }
                 if (ch == "=")
                  {
                    line = line ">04*Y"
                    action = 1
                  }
                 if (ch == "b")
                  {
                    line = line "B"
                    action = 1
                  }
                 if (ch == "B")
                  {
                    line = line ">1&*B"
                    action = 1
                  }
                 if (ch == "-")
                  {
                    line = line "O"
                    action = 1
                  }
                 if (ch == "_")
                  {
                    line = line ">03*O"
                    action = 1
                  }
                 if (ch == ":")
                  {
                    line = line "Z"
                    action = 1
                  }
                 if (action == 0)
                   line = line ch
               }
            }
           else
             line = line ch
         }
      }
     print line
   }
  else
    print $0
}
