#  $Id: ddiff1.awk 0.03 2000/03/20 00:00:03 tom Exp $
#
#  ddiff1.awk:  Computes the minimum and maximum day lengths of a
#                 definite location and prints these values, assigned
#                 to variables, as the beginning of an AWK script,
#                 which is used to create a Gcal location resource file.
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
BEGIN {
  dmin = 99999
  dmax = 0
}
#
# Main block.
#
{
  t = substr($3, 1, 2) * 3600 + substr($3, 4, 2) * 60
  if (length($3) > 7)
    t += substr($3, 7, 6)
  if (dmax < t)
    dmax = t
  if (dmin > t)
    dmin = t
}
END {
  printf "BEGIN {\n  dmin = %f;\n  dmax = %f;\n", dmin, dmax
}
