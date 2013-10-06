DEFAULT: testlib.o
	idris myffi.idr -o myffi

clean:
	rm -f myffi testlib.o myffi.ibc
