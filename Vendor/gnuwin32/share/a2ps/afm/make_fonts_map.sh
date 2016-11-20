#! /bin/sh
#
# This file is part of a2ps.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; see the file COPYING.  If not, write to
# the Free Software Foundation, 59 Temple Place - Suite 330,
# Boston, MA 02111-1307, USA.
#

#
# This shell script is ment to ease the writing of the fonts.map
# file.  Once a2ps is installed, just run this script.
#

# Exit whenever there is a problem
set -e

/bin/rm -rf fonts.map.new fonts.map.tmp
LC_ALL=C
export LC_ALL

files=
A2PS=${A2PS:-a2ps}

# The width of the first columns
many_spaces="                              "
many_dots=`echo "$many_spaces" | sed -e 's/ /./g'`

# First we want to get all the AFM files
echo "Looking for the afm files read by ${A2PS}..." 1>&2
for directory in `$A2PS --list-options | grep '^	/'`
do
  echo "  $directory..." 1>&2
  newfiles=`echo $directory/*.afm 2> /dev/null`
  case "$newfiles" in
    */\*.afm) # nothing found here
       ;;
    *) # echo "     $newfiles" | sed -e "s!$directory/!!g" 1>&2
       files=`echo $newfiles $files`
       ;;
  esac
done

# Extract there names
echo "Extracting font names..." 1>&2
for file in $files
do
  # Extract the font name.
  name=`sed -n -e '/^FontName/{
s/FontName[ ]*\([-a-zA-Z]*\).*/\1/p
q
}' $file`
  shortname=`basename $file | sed -e 's/\.[^\.]*$//g'`
  if test x$name = x; then :; else
    # This is probably not a correct AFM file.
    # (For instance Ogonkify's pseudo AFMs that define the encodings)
    # Forget it.
    col1=`echo "$name$many_spaces" | sed -e 's/^\('$many_dots'\).*$/\1/g'`
    # Make sure the name has not been cut
    case "$col1" in
      $name*) ;;
      *) echo "A name has been cut ($name -> $col1)." 1>&2
	 exit 1 ;;
    esac
    col2="$shortname"
    echo "$col1$col2" >> fonts.map.new
  fi
done

# Sort them by name, and keep a unique file for each font
echo "Sorting entries..." 1>&2
sort -u -t' ' +0 -1 fonts.map.new > fonts.map.tmp

echo "Finishing." 1>&2
cat > fonts.map.new <<EOF
# -*- ksh -*-
#
# This file is part of a2ps.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; see the file COPYING.  If not, write to
# the Free Software Foundation, 59 Temple Place - Suite 330,
# Boston, MA 02111-1307, USA.
#

#
# This file defines the rules used by a2ps to recognize the file
# name of a font given the font name.
#
# The format of each line is:
#
# <font name> <font file key>
#	In which case whenever <font name> is requested, a2ps uses the
#	files <font file key>.afm to get the font information, and the
#	files <font file key>.pfa or pfb when it needs to download it
#	to the printer.
#
# *** <path>
#	In which case a encoding.map is included at this point.
#	This may be the case if you define a personal extension
#	of the system's fonts.map
#
# A shell script has been provided with a2ps, and should be able to
# write this file for you.
# Just hit: \`make_fonts_map.sh'
#
EOF

cat fonts.map.tmp >> fonts.map.new
chmod 644 fonts.map.new
rm fonts.map.tmp

# Make a message for the user
cat <<EOF
*******************************************************************
* A new fonts.map has been created: \`fonts.map.new'               *
* Please check that it is correct, and rename it as \`fonts.map':  *
*     mv fonts.map.new fonts.map                                  *
*******************************************************************
EOF

# Local Variables:
# mode:ksh
# sh-indentation:2
# End:
