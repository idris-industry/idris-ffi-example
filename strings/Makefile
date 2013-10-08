all: strings bad_strings

bad_strings: testlib.o bad_strings.idr
	idris bad_strings.idr -o bad_strings

strings: testlib.o strings.idr
	idris strings.idr -o strings

clean:
	rm -f testlib.o bad_strings bad_strings.ibc strings strings.ibc
