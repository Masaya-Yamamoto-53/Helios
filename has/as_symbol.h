#ifndef _HAS_SYMBOL_H_
#define _HAS_SYMBOL_H_

#define N_CONST  (0)
#define N_DISP   (1)
#define N_SIMM13 (2)
#define N_DISP23 (3)
#define N_DISP32 (4)

struct symbol {
    char *name;
    int nodetype;
    int value;
    struct symbol *next;     /* for tbl */
    struct symbol *next_sym; /* next .const */
};

struct symbol *newsym (char *name, int type, int value);
struct symbol *getsym (char *name);
void entry (struct symbol *sym);

#endif /* _HAS_SYMBOL_H_ */
