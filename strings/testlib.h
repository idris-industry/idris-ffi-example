/* A variable string */
char *var;

/* A wrapper function returning the above variable. This is necessary to access
 * "var" from Idris */
char *var_wrapper(void);

/* Returns "Hello, world!" */
char *not_null(void);

/* Returns NULL */
char *null(void);

/* Returns consecutive numbers as a string */
char *next(void);
