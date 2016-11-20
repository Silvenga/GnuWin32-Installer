# Rule to make compiled resource (Windows)
%-rc.o: %.rc
	windres -i $< -o $@

CFLAGS=  -DWINDOWS -D__GW32__ -D_LARGEFILE_SOURCE=1 -D_LARGEFILE64_SOURCE=1 -D_FILE_OFFSET_BITS=64 \
	-Wall -Os -mms-bitfields  -fno-exceptions -fomit-frame-pointer -march=i386 -mcpu=i686 \
	-Wl,-s

nsfix.exe: nsfix.c nsfix-rc.o 
	$(CC) $(CFLAGS) -o nsfix.exe nsfix.c nsfix-rc.o $(LDFLAGS)

clean:
	rm -f *.o core *.core core.* nsfix.exe
