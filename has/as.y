%{
#include <stdio.h>
#include <stdlib.h>

#include "as_op.h"
#include "as_ast.h"
#include "as_symbol.h"

static void dec2bin (char *str, unsigned int num, int count);
static void printfmt0 (struct ast *a);
static void printfmt1 (struct ast *a);
static void printfmt2 (struct ast *a);
static void printfmt3 (struct ast *a);
int yyerror (char *s);

static unsigned int as_address = 0;
static unsigned int as_line = 0;

%}

%union {
    int   d;
    char *s;
    struct ast    *ast;
    struct symbol *sym;
}

/* declare tokens */
%token T_EOL
%token <s> T_UNDEFSYM
%token <s> T_LABEL
%token <d> T_REGISTER
%token <d> T_IMM

/* Format0 Instruction */
%token <d> T_SETHI
%token <d> T_BR

/* Format1 Instruction */
%token <d> T_CALL

/* Format2 Instruction */
%token <d> T_FMT2 T_SEXTB T_SEXTH

/* Format3 Instruction */
%token <d> T_FMT3
%token <d> T_RETT
%token <d> T_PRRD T_PRWR
%token <d> T_EI T_DI T_PILWR

/* Pseudo Instruction */
%token <d> T_MOV
%token <d> T_INC T_DEC
%token <d> T_BSET T_BCLR T_BTOG
%token <d> T_RET
%token <d> T_NOP

/* unimp */
%token <d> T_UNIMP

%token T_UNDEF

%type <d> disp30
%type <d> disp19
%type <d> sethi23
%type <d> simm13

%type <d> fmt0_cond
%type <d> fmt2_op3 fmt3_op3
%type <ast> instruction
%type <ast> instructions
%type <ast> instruction_format0
%type <ast> instruction_format1
%type <ast> instruction_format2
%type <ast> instruction_format3
%type <ast> synthetic_instruction

%start top
%%

top : instruction {
                       struct ast *p;
                       p = $1;
                       while (p != NULL) {
                           switch (p->nodetype) {
                               case T_INST_FMT0:
                                   printfmt0 (p);
                                   break;
                               case T_INST_FMT1:
                                   printfmt1 (p);
                                   break;
                               case T_INST_FMT2:
                                   printfmt2 (p);
                                   break;
                               case T_INST_FMT3:
                                   printfmt3 (p);
                                   break;
                               default:
                                   fprintf (stderr, "has: error: Nodo Type not defined.\n");
                                   break;
                           }
                           p = p->next;
                       }
                  }

instruction : /* nothing*/             { $$ = NULL; }
            | instructions instruction {
                                            struct ast *p;
                                            p = $1;
                                            if (p == NULL) {
                                                $$ = $2;
                                            }
                                            else {
                                                while (p->next != NULL) {
                                                    p = p->next;
                                                }
                                                p->next = $2;
                                                $$ = $1;
                                            }
                                       }
            ;
            
instructions : instruction_format0   T_EOL { $$ = $1; as_line++; as_address++; }
             | instruction_format1   T_EOL { $$ = $1; as_line++; as_address++; }
             | instruction_format2   T_EOL { $$ = $1; as_line++; as_address++; }
             | instruction_format3   T_EOL { $$ = $1; as_line++; as_address++; }
             | synthetic_instruction T_EOL { $$ = $1; as_line++; as_address++; }
             | T_LABEL               T_EOL {
                                                struct symbol *sym;

                                                as_line++;

                                                sym = newsym ($1, N_DISP, as_address << 2);
                                                if (getsym (sym->name) != NULL) {
                                                    fprintf (stderr, "error: %d: invalid symbol redefinition\n", as_line);
                                                    exit (0);
                                                }
                                                entry (sym);

                                                $$ = NULL;
                                           }
             | T_EOL                       {
                                                as_line++;
                                                $$ = NULL;
                                           }
             ;

instruction_format0 : T_SETHI   T_REGISTER ',' sethi23    { $$ = newifmt0 ( 0, $2,          0, $4, NULL, FMT0_OP2_SETHI); }
                    | fmt0_cond T_REGISTER ',' disp19     { $$ = newifmt0 ($1, $2, as_address, $4, NULL, FMT0_OP2_BR   ); }
                    | fmt0_cond T_REGISTER ',' T_UNDEFSYM { $$ = newifmt0 ($1, $2, as_address,  0,   $4, FMT0_OP2_BR   ); }
                    ;

instruction_format1 : T_CALL disp30     { $$ = newifmt1 ($2, NULL, as_address); }
                    | T_CALL T_UNDEFSYM { $$ = newifmt1 ( 0, $2  , as_address); }
                    ;

instruction_format2 : fmt2_op3 T_REGISTER ',' T_REGISTER ',' T_REGISTER { $$ = newifmt2 ($2, $4, $1, 0, $6); }
                    | fmt2_op3 T_REGISTER ',' T_REGISTER ',' simm13     { $$ = newifmt2 ($2, $4, $1, 1, $6); }
                    | T_SEXTB  T_REGISTER ',' T_REGISTER                { $$ = newifmt2 ($2, $4, FMT2_OP3_SEXTB, 0, 0); }
                    | T_SEXTH  T_REGISTER ',' T_REGISTER                { $$ = newifmt2 ($2, $4, FMT2_OP3_SEXTH, 0, 0); }
                    ;

instruction_format3 : fmt3_op3 T_REGISTER ',' T_REGISTER ',' T_REGISTER       { $$ = newifmt3 ($2, $4, $1, 0, $6); }
                    | fmt3_op3 T_REGISTER ',' T_REGISTER ',' simm13           { $$ = newifmt3 ($2, $4, $1, 1, $6); }
                    | fmt3_op3 T_REGISTER ',' T_REGISTER ',' simm13 '+' T_IMM {
                                                                                  int tmp = $6 + $8;
                                                                                  if ((tmp >= -4096)
                                                                                   && (tmp <=  4095)) {
                                                                                      $$ = newifmt3 ($2, $4, $1, 1, tmp);
                                                                                  } else {
                                                                                      fprintf(stderr, "erroe simm13 overflow\n");
                                                                                  }
                                                                              }
                    ;

synthetic_instruction : T_MOV T_REGISTER ',' T_REGISTER   { $$ = newifmt2 ($2, 0, $1, 0, $4); }
                      | T_MOV T_REGISTER ',' T_IMM        {
                                                              if (($4 >= -4096)
                                                               && ($4 <=  4095)) {
                                                                  $$ = newifmt2 ($2, 0, $1, 1, $4);
                                                              }
                                                              else {
                                                                  if ($4 & 0x01FF) {
                                                                      as_address++;
                                                                      $$       = newifmt0 (0, $2, 0, $4 >> 9, NULL, FMT0_OP2_SETHI);
                                                                      $$->next = newifmt2 ($2, $2, $1, 1, $4 & 0x01FF);
                                                                  }
                                                                  else {
                                                                      $$       = newifmt0 (0, $2, 0, $4 >> 9, NULL, FMT0_OP2_SETHI);
                                                                  }
                                                              }
                                                          }
                      | T_MOV  T_REGISTER ',' T_UNDEFSYM  {
                                                               struct symbol *sym;

                                                               sym = getsym ($4);
                                                               if (sym == NULL) {
                                                                   fprintf (stderr, "error: undefined symbol 'sethi %s'.\n", $4);
                                                                   exit (0);
                                                               }
                                                               if (sym->nodetype == N_SIMM13) {
                                                                   $$ = newifmt2 ($2, 0, $1, 1, sym->value);
                                                               }
                                                               if (sym->nodetype == N_DISP23) {
                                                                   $$ = newifmt0 (0, $2, 0, sym->value >> 9, NULL, FMT0_OP2_SETHI);
                                                               }
                                                               if (sym->nodetype == N_DISP32) {
                                                                   as_address++;
                                                                   $$       = newifmt0 (0, $2, 0, sym->value >> 9, NULL, FMT0_OP2_SETHI);
                                                                   $$->next = newifmt2 ($2, $2, $1, 1, sym->value & 0x01FF);
                                                               }
                                                          }
                      | T_INC  T_REGISTER                 { $$ = newifmt2 ($2, $2, $1, 1,  1); }
                      | T_DEC  T_REGISTER                 { $$ = newifmt2 ($2, $2, $1, 1,  1); }
                      | T_BSET T_REGISTER ',' simm13      { $$ = newifmt2 ($2, $2, $1, 1, $4); }
                      | T_BCLR T_REGISTER ',' simm13      { $$ = newifmt2 ($2, $2, $1, 1, $4); }
                      | T_BTOG T_REGISTER ',' simm13      { $$ = newifmt2 ($2, $2, $1, 1, $4); }
                      | T_RET                             { $$ = newifmt3 ( 0, 29, $1, 1,  4); }
                      | T_NOP                             { $$ = newifmt0 ( 0,  0,  0, 0, NULL, 0); }
                      | T_PRRD T_REGISTER                 { $$ = newifmt3 ($2,  0, $1, 0,   0); }
                      | T_PRWR T_REGISTER ',' T_REGISTER  { $$ = newifmt3 ( 0, $2, $1, 0,  $4); }
                      | T_PRWR T_REGISTER ',' simm13      { $$ = newifmt3 ( 0, $2, $1, 1,  $4); }
                      | T_RETT                            { $$ = newifmt3 ( 0, 31, $1, 1,   4); }
                      | T_EI                              { $$ = newifmt3 ( 0,  0, $1, 1,0x10); }
                      | T_DI                              { $$ = newifmt3 ( 0,  0, $1, 1,0x00); }
                      | T_PILWR T_REGISTER ',' T_REGISTER { $$ = newifmt3 ( 0, $2, $1, 0,  $4); }
                      | T_PILWR T_REGISTER ',' simm13     { $$ = newifmt3 ( 0, $2, $1, 1,  $4); }
                      | T_UNIMP                           { $$ = newifmt3 ( 0,  0, $1, 1,   0); }
                      ;

disp30  : T_IMM {
                     int disp30;

                     disp30 = $$ >> 2;
                     if ((disp30 >= (int)0xC0000000)
                      && (disp30 <= (int)0x3FFFFFFF)) {
                         $$ = disp30;
                     } else {
                         $$ = 0;
                         fprintf (stderr, "error: %d: disp30 out of range(%d).\n", as_line, $1);
                         yyerror (0);
                     }
                }
disp19  : T_IMM {
                     int disp19;

                     disp19 = $$ >> 2;
                     if ((disp19 >= (int)0xFFFC0000)
                      && (disp19 <= (int)0x0003FFFF)) {
                         $$ = disp19;
                     } else {
                         $$ = 0;
                         fprintf (stderr, "error: %d: disp19 out of range(%d).\n", as_line, $1);
                         yyerror (0);
                     }
                }
sethi23 : T_IMM {
                     if (($1 >= (int)0xFFBFFFFF)
                      && ($1 <= (int)0x00400000)) {
                         $$ = $1;
                     } else {
                         $$ = 0;
                         fprintf (stderr, "error: %d: sethi23 out of range(%d).\n", as_line, $1);
                         yyerror (0);
                     }
                }
simm13  : T_IMM {
                     if (($1 >= -4096)
                      && ($1 <=  4095)) {
                         $$ = $1;
                     } else {
                         $$ = 0;
                         fprintf (stderr, "error: %d: simm13 out of range(%d).\n", as_line, $1);
                         yyerror (0);
                     }
                }

fmt0_cond : T_BR   { $$ = $1; }
          ;
fmt2_op3  : T_FMT2 { $$ = $1; }
          ;
fmt3_op3  : T_FMT3 { $$ = $1; }
          ;

%%

static void dec2bin (char *str, unsigned int num, int count)
{
    int i;
    for (i = 0; i < count; i++) {
        str [count-1-i] = ((num >> i) & 0x01) + 0x30;
    }
    str [count] = '\0';
}

static void printfmt0_sethi (struct inst_format0 *ifmt0)
{
    char disp_hi    [20+1];
    char disp_lo    [ 3+1];
    char rs3        [ 5+1];
    char op2        [ 2+1];

    dec2bin (rs3,  ifmt0->rs3,  5);
    dec2bin (op2,  ifmt0->op2,  2);

    printf ("00"); /* format 0 */

    if (ifmt0->op2 == 0) {
        if (ifmt0->label == NULL) {
            dec2bin (disp_hi, ifmt0->disp >> 3, 20);
            dec2bin (disp_lo, ifmt0->disp     ,  3);
        }
        else {
            fprintf (stderr, "printfmt0_sethi: why?\n");
        }
        printf ("%s", disp_hi);
        printf ("%s", rs3);
        printf ("%s", op2);
        printf ("%s", disp_lo);
    } else {
        fprintf (stderr, "error: undefined op2(%d).\n", ifmt0->op2);
    }
    printf ("\n");
}

static void printfmt0_pbr (struct inst_format0 *ifmt0)
{
    struct symbol *sym;
    int disp;
    char p          [ 1+1];
    char cond       [ 3+1];
    char rs3        [ 5+1];
    char disp_hi    [20+1];
    char disp_lo    [ 3+1];
    char op2        [ 2+1];

    if (ifmt0->label != NULL) {
        sym = getsym (ifmt0->label);
        if (sym == NULL) {
            fprintf (stderr, "error: undefined symbol (%s)\n", ifmt0->label);
            exit (0);
        }
        if (sym->nodetype != N_DISP) {
            fprintf (stderr, "why?\n");
            exit (0);
        }
        disp = (sym->value >> 2) - ifmt0->pc;
    }
    else
    {
        disp = ifmt0->disp - ifmt0->pc;
    }

    ifmt0->p = (disp <= 0);

    dec2bin (p,    ifmt0->p,    1);
    dec2bin (cond, ifmt0->cond, 3);
    dec2bin (rs3,  ifmt0->rs3,  5);
    dec2bin (op2,  ifmt0->op2,  2);

    printf ("00"); /* format 0 */

    if (ifmt0->op2 == 1) {
        if (ifmt0->label == NULL) {
            dec2bin (disp_hi, ifmt0->disp >> 3, 16);
            dec2bin (disp_lo, ifmt0->disp     ,  3);
        } else {
            dec2bin (disp_hi, disp >> 3, 16);
            dec2bin (disp_lo, disp     ,  3);
        }
        printf ("%s", disp_hi);
        printf ("%s", p);
        printf ("%s", cond);
        printf ("%s", rs3);
        printf ("%s", op2);
        printf ("%s", disp_lo);
    } else {
        fprintf (stderr, "why?\n");
    }
    printf ("\n");
}

static void printfmt0 (struct ast *a)
{
    struct inst_format0 *ifmt0;

    ifmt0 = (struct inst_format0 *)a;

    /* sethi instruction */
    if (ifmt0->op2 == 0) {
        printfmt0_sethi (ifmt0);
    }
    /* prediction branch */
    else if (ifmt0->op2 == 1) {
        printfmt0_pbr (ifmt0);
    }
    else {
        fprintf (stderr, "error: undefined op2(%d).\n", ifmt0->op2);
    }
}

void printfmt1 (struct ast *a)
{
    struct inst_format1 *ifmt1;
    struct symbol *sym;
    char disp30  [30+1];

    ifmt1 = (struct inst_format1 *)a;

    if (ifmt1->label == NULL) {
        dec2bin (disp30, ifmt1->disp30 - ifmt1->pc, 30);
    } else {
        sym = getsym (ifmt1->label);
        if (sym == NULL) {
            printf ("as: error: undefined symbol (%s)\n", ifmt1->label);
        }
        dec2bin (disp30, (sym->value >> 2) - ifmt1->pc, 30);
    }

    printf ("01"); /* format 0 */

    printf ("%s", disp30);
    printf ("\n");
}

static void printfmt2 (struct ast *a)
{
    struct inst_format2 *ifmt2;
    char rd  [5+1];
    char op3 [6+1];
    char rs1 [5+1];
    char rs2 [5+1];
    char simm13 [13+1];

    ifmt2 = (struct inst_format2 *)a;

    dec2bin (rd,     ifmt2->rd,  5);
    dec2bin (op3,    ifmt2->op3, 6);
    dec2bin (rs1,    ifmt2->rs1, 5);
    dec2bin (rs2,    ifmt2->operand2,  5);
    dec2bin (simm13, ifmt2->operand2, 13);

    printf ("10"); /* format 2 */
    printf ("%s", rd);
    printf ("%s", op3);
    printf ("%s", rs1);
    if (ifmt2->i == 0) {
        printf ("0");
        printf ("00000000");
        printf ("%s",rs2);
    }
    else
    {
        printf ("1");
        printf ("%s",simm13);
    }
    printf ("\n");
}

static void printfmt3 (struct ast *a)
{
    struct inst_format3 *ifmt3;
    char rd  [5+1];
    char op3 [6+1];
    char rs1 [5+1];
    char rs2 [5+1];
    char simm13 [13+1];

    ifmt3 = (struct inst_format3 *)a;

    dec2bin (rd,     ifmt3->rd,  5);
    dec2bin (op3,    ifmt3->op3, 6);
    dec2bin (rs1,    ifmt3->rs1, 5);
    dec2bin (rs2,    ifmt3->operand2,  5);
    dec2bin (simm13, ifmt3->operand2, 13);

    printf ("11"); /* format 3 */
    printf ("%s", rd);
    printf ("%s", op3);
    printf ("%s", rs1);
    if (ifmt3->i == 0) {
        printf ("0");
        printf ("00000000");
        printf ("%s",rs2);
    }
    else
    {
        printf ("1");
        printf ("%s",simm13);
    }
    printf ("\n");
}

int yyerror (char *s)
{
    fprintf (stderr, "error: %s\n", s);
    return -1;
}

int main (int argc, char *argv[])
{
    extern FILE *yyin;

    if (argc > 1 && (yyin = fopen (argv[1], "r")) == NULL) {
        perror (argv[1]);
        exit (1);
    }
    yyparse ();
    return 0;
}
