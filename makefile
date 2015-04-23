CC = gcc
CFLAGS = -Wall -g
LDFLAGS = 

COMPRESS = gzip

all: myprog

myprog: main.o input.o
	$(CC) main.o input.o -o myprog  

main.o: main.c input.c utils.h types.h defs.h
	$(CC) $(CFLAGS) main.c

input.o: input.c types.h
	$(CC) $(CFLAGS) input.c

clean:
	rm -f *.o

install:
	cp myprog /usr/bin/
	chmod 555 /usr/bin/myprog

