
PROGS= bz cmpf dmpf

BZOBJS= bz.o bzscreen.o	bz-rc.o

CFLAGS= -DWINDOWS -D__GW32__ -D_LARGEFILE_SOURCE=1 -D_LARGEFILE64_SOURCE=1 -D_FILE_OFFSET_BITS=64 \
	-Wall -Os -mms-bitfields  -fno-exceptions -fomit-frame-pointer -march=i386 -mcpu=i686 \
	-Wl,-s

# Rule to make compiled resource (Windows)
%-rc.o: %.rc
	windres -i $< -o $@

all: $(PROGS)

clean:
	rm -f $(PROGS) *.o *.core core.* core *.exe

bz: $(BZOBJS)
	$(CC) $(CFLAGS) -o bz $(BZOBJS)

cmpf: cmpf.c bmpfont.h cmpf-rc.o
	$(CC) $(CFLAGS) -o cmpf cmpf.c cmpf-rc.o -lt1 -lm

dmpf: dmpf.c bmpfont.h dmpf-rc.o
	$(CC) $(CFLAGS) -o dmpf dmpf.c dmpf-rc.o -lt1 -lm
