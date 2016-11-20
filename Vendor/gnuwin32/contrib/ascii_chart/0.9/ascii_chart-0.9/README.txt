The program ascii_chart (http://biolpc22.york.ac.uk/linux/plotutils)

This program takes data in a two column ascii format (labels, data; see Sample data files) and plots them 
using the libplot routine of the plotutils package. It is based on the piechart program of  Bernhard Reiter, 
without which I could not have written the code which plotted the linebars. Both this program and its 
piechart basis are released under the GPL version 2.

To install it you need the makefile and source listed below and the plotutils-2.2 package.  This is best 
downloaded fom a mirror of the www.gnu.org site.
You will have to alter the Makefile to reflect the places in which you put the library libplot.so the binary 
files (eg plot) and the source files from the plotutils package.

To run  the program use a command line like thes two examples where the display type, title, axis labels 
etc are provided by command line parameters and the data from an ascii file

ascii_chart -TX -t title -X "x axis" -Y "y axis" < months.dat
ascii_chart -TX -t title -P -r 0.6 -d 0.2 < spring.dat

Output can be sent to an X display, tektronix 4014 display, to a gif, ps or pcl file, or several other devices 
supported by the plotutils library. The gif files from the sample data look like this (click the image to see 
enlarged version)

Sample Data files are provided in the distribution

      months.dat      
      probe.dat       
      spring.dat



Chris Elliott, cje2@york.ac.uk, 15 Sept 1999
