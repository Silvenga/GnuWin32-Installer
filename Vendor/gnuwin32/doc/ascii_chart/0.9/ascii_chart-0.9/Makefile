# $Id: makefile,v 1.6 1999/04/03 10:19:43 breiter Exp $

# you have to change the following paths to where you have installed plotutils
BASE=/usr/src/plotutils-2.2
PLOTLIBPATH=/usr/local/lib
PLOTBINPATH=/usr/local/bin
PLOTINCLUDEPATH=$(BASE)/include

PLOT2X=$(PLOTBINPATH)/plot -T X

CC=gcc -Wall -ansi-strict
CFLAGS= -I$(PLOTINCLUDEPATH)
#CFLAGS= -g -I$(PLOTINCLUDEPATH) -DDEBUG
LDFLAGS= -L$(PLOTLIBPATH)

# for OSF1/alpha 4.0d's cc, try
#CC=cc -w0 -std1


all: ascii_chart test


test:: ascii_chart probe.dat
	<probe.dat ./ascii_chart -P -r0.6 -d0.05 -C skyblue2,green,aquamarine -t "Hello World" | $(PLOT2X)
	<probe.dat ./ascii_chart -X "x axis" -Y "Y axis" -t "Hello World" -TX

	
probe.dat:
	echo '#just a very small input file for testing piechart'>probe.dat
	echo 'Bernhard 50'  >>probe.dat
	echo 'Cliff	20' >>probe.dat
	echo 'Joe Box 10'   >>probe.dat
	
ascii_chart: ascii_chart.c $(PLOTLIBPATH)/libplot.so
	$(CC) $(CFLAGS) $(LDFLAGS) \
		ascii_chart.c -o $@ -lplot -lm
