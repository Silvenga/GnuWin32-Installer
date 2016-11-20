# This file is (c) 1998 Ted Faber (faber@lunabase.org) see COPYRIGHT
# for the full copyright and limitations of liabilities.

srcdir = ../../grap-1.43-src/examples
VPATH = ../../grap-1.43-src/examples

MACROS=-ms 

all: example.ps local.example.ps

example.ps:	example.ms
	grap -M $(srcdir) $? | groff -pe $(MACROS) > example.ps

local.example.ps:	example.ms
	../grap -d ../grap.defines -M $(srcdir) $? | groff -pe $(MACROS) > local.example.ps

clean:
	rm -f *.ps *.pdf *.ps.gz *core
