idris-ffi-example
=================

This is a collection of examples of how to use the Idris FFI.

## myFirstFFI
We have a C library testlib with a function `int foo(int);` that takes an int,
adds 1 to the argument and returns the result. The Idris program calls foo with
`42` as argument and then prints the result.

## strings
We have two functions that return a `char` pointer. One of them will always
return a C-string while the other always returns `NULL`. Note that the example
doesn't work in v0.9.9.2.
