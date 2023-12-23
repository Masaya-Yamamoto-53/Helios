#ifndef _AS_AST_H_
#define _AS_AST_H_

#include "as_symbol.h"

enum nodetype {
    T_INST_FMT0,
    T_INST_FMT1,
    T_INST_FMT2,
    T_INST_FMT3
};

struct ast {
    int nodetype;
    struct ast *next;
};

struct inst_format0 {
    int nodetype;
    struct ast *next;
    char p;
    char cond;
    char rs3;
    int pc;
    int disp;
    char *label;
    char op2;
};

struct inst_format1 {
    int nodetype;
    struct ast *next;
    int disp30;
    char *label;
    int pc;
};

struct inst_format2 {
    int nodetype;
    struct ast *next;
    char rd;
    char rs1;
    char op3;
    char i;
    short operand2;
};

struct inst_format3 {
    int nodetype;
    struct ast *next;
    char rd;
    char rs1;
    char op3;
    char i;
    short operand2;
};

struct ast *newast (int nodetype, struct ast *next);
struct ast *newifmt0 (char cond, char rs3, int pc, int disp, char *label, char op2);
struct ast *newifmt1 (int disp30, char *label, int pc);
struct ast *newifmt2 (char rd, char rs1, char op3, char i, short operand2);
struct ast *newifmt3 (char rd, char rs1, char op3, char i, short operand2);

#endif /* _AS_AST_H_ */
