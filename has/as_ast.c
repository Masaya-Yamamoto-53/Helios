#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

#include "as_ast.h"
#include "as_symbol.h"
#include "as.tab.h"

struct ast *newast (int nodetype, struct ast *next)
{
    struct ast *a;
    
    a = malloc (sizeof (struct ast));
    if (a == NULL) {
        fprintf (stderr, "error: out of space.\n");
        exit (0);
    }
    a->nodetype = nodetype;
    a->next = next;

    return a;
}

struct ast *newifmt0 (char cond, char rs3, int pc, int value, char *label, char op2)
{
    char *s;
    struct inst_format0 *a;
    
    a  = malloc (sizeof (struct inst_format0));
    if (a == NULL) {
        fprintf (stderr, "error: out of space.\n");
        exit (0);
    }

    s = NULL;
    if (label != NULL) {
       s = malloc (strlen (label)+1);
       strcpy (s, label);
    }

    a->nodetype = T_INST_FMT0;
    a->next     = NULL;
    a->p        = 0;
    a->cond     = cond;
    a->rs3      = rs3;
    a->pc       = pc;
    a->disp     = value; /* disp19 or sethi21 */
    a->label    = s;
    a->op2      = op2;

    return (struct ast *)a;
}

struct ast *newifmt1 (int disp30, char *label, int pc)
{
    char *s;
    struct inst_format1 *a;
    
    a = malloc (sizeof (struct inst_format1));
    if (a == NULL) {
        fprintf (stderr, "error: out of space.\n");
        exit (0);
    }
    if (label != NULL) {
       s = malloc (strlen (label)+1);
       strcpy (s, label);
    }

    a->nodetype = T_INST_FMT1;
    a->next     = NULL;
    a->disp30   = disp30;
    a->label    = s;
    a->pc       = pc;

    return (struct ast *)a;
}

struct ast *newifmt2 (char rd, char rs1, char op3, char i, short operand2)
{
    struct inst_format2 *a = malloc (sizeof (struct inst_format2));

    if (!a) {
        fprintf (stderr, "error: out of space.\n");
        exit (0);
    }
    a->nodetype = T_INST_FMT2;
    a->next     = NULL;
    a->rd       = rd;
    a->rs1      = rs1;
    a->op3      = op3;
    a->i        = i;
    a->operand2 = operand2;

    return (struct ast *)a;
}

struct ast *newifmt3 (char rd, char rs1, char op3, char i, short operand2)
{
    struct inst_format3 *a = malloc (sizeof (struct inst_format3));

    if (!a) {
        fprintf (stderr, "error: out of space.\n");
        exit (0);
    }
    a->nodetype = T_INST_FMT3;
    a->next     = NULL;
    a->rd       = rd;
    a->rs1      = rs1;
    a->op3      = op3;
    a->i        = i;
    a->operand2 = operand2;

    return (struct ast *)a;
}
