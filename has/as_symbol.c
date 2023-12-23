#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

#include "as_symbol.h"

#define NHASH (13)

struct symbol *hash_tbl [NHASH];

static int hash (char *s)
{
    int i;
    int len;
    int hash;

    len = strnlen (s, 32);
    hash = 0;
    for (i = 0; i < len; i++) {
        hash += s[i];
    }
    return hash % NHASH;
}

struct symbol *newsym (char *name, int type, int value)
{
    struct symbol *sym;
    char *n;

    sym = malloc (sizeof (struct symbol));
    if (sym == NULL) {
        // yyerror
        exit (0);
    }
    n = malloc (strlen (name)+1);
    strcpy (n, name);
    sym->name     = n;
    sym->nodetype = type;
    sym->value    = value;
    sym->next     = NULL;
    sym->next_sym = NULL;

    return sym;
}

struct symbol *getsym (char *name)
{
    struct symbol *p;
    int h;
    int cmp;

    h = hash (name);
    p = hash_tbl [h];

    while (p != NULL) {
        cmp = strcmp(name, p->name);
        if (cmp == 0) {
            return p;
        }
        p = p->next;
    }
    return NULL;
}

void entry (struct symbol *sym)
{
    char *symname;
    int h;
    struct symbol *p;
    
    p = getsym (sym->name);

    if (p == NULL) {
        h = hash (sym->name);

        if (hash_tbl [h] == NULL) {
            hash_tbl [h] = sym;
        }
        else {
            p = hash_tbl [h];
            while (p->next != NULL) {
                p = p->next;
            }
            p->next = sym;
        }
    }
    else {
        fprintf (stderr, "error: previous declaration of '%s:' was here.\n", sym->name);
        exit (0);
    }
}
