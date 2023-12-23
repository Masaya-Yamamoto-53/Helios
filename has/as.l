%option noyywrap nodefault yylineno
%{
#include <stdio.h>
#include <string.h>

#include "as_op.h"
#include "as.tab.h"
#include "as_symbol.h"

struct st_reserved_word {
    char *inst;
    int  type;
    int  opcode;
};

struct st_reserved_word inst [] = {
    {"sethi"  ,T_SETHI  ,-1              },
    {"brlbc"  ,T_BR     ,FMT0_COND_BRLBC },
    {"brz"    ,T_BR     ,FMT0_COND_BRZ   },
    {"brlz"   ,T_BR     ,FMT0_COND_BRLZ  },
    {"brlez"  ,T_BR     ,FMT0_COND_BRLEZ },
    {"brlbs"  ,T_BR     ,FMT0_COND_BRLBS },
    {"brnz"   ,T_BR     ,FMT0_COND_BRNZ  },
    {"brgz"   ,T_BR     ,FMT0_COND_BRGZ  },
    {"brgez"  ,T_BR     ,FMT0_COND_BRGEZ },
    {"call"   ,T_CALL   ,-1              },
    {"add"    ,T_FMT2   ,FMT2_OP3_ADD    },
    {"and"    ,T_FMT2   ,FMT2_OP3_AND    },
    {"or"     ,T_FMT2   ,FMT2_OP3_OR     },
    {"xor"    ,T_FMT2   ,FMT2_OP3_XOR    },
    {"sub"    ,T_FMT2   ,FMT2_OP3_SUB    },
    {"andn"   ,T_FMT2   ,FMT2_OP3_ANDN   },
    {"orn"    ,T_FMT2   ,FMT2_OP3_ORN    },
    {"xnor"   ,T_FMT2   ,FMT2_OP3_XNOR   },
    {"mul"    ,T_FMT2   ,FMT2_OP3_MUL    },
    {"umulh"  ,T_FMT2   ,FMT2_OP3_UMULH  },
    {"sll"    ,T_FMT2   ,FMT2_OP3_SLL    },
    {"srl"    ,T_FMT2   ,FMT2_OP3_SRL    },
    {"sra"    ,T_FMT2   ,FMT2_OP3_SRA    },
    {"sextb"  ,T_SEXTB  ,FMT2_OP3_SEXTB  },
    {"sexth"  ,T_SEXTH  ,FMT2_OP3_SEXTH  },
    {"cmpeq"  ,T_FMT2   ,FMT2_OP3_CMPEQ  },
    {"cmplt"  ,T_FMT2   ,FMT2_OP3_CMPLT  },
    {"cmple"  ,T_FMT2   ,FMT2_OP3_CMPLE  },
    {"cmpneq" ,T_FMT2   ,FMT2_OP3_CMPNEQ },
    {"cmpltu" ,T_FMT2   ,FMT2_OP3_CMPLTU },
    {"cmpleu" ,T_FMT2   ,FMT2_OP3_CMPLEU },
    {"ldub"   ,T_FMT3   ,FMT3_OP3_LDUB   },
    {"lduh"   ,T_FMT3   ,FMT3_OP3_LDUH   },
    {"ld"     ,T_FMT3   ,FMT3_OP3_LD     },
    {"ldsb"   ,T_FMT3   ,FMT3_OP3_LDSB   },
    {"ldsh"   ,T_FMT3   ,FMT3_OP3_LDSH   },
    {"stb"    ,T_FMT3   ,FMT3_OP3_STB    },
    {"sth"    ,T_FMT3   ,FMT3_OP3_STH    },
    {"st"     ,T_FMT3   ,FMT3_OP3_ST     },
    {"jmpl"   ,T_FMT3   ,FMT3_OP3_JMPL   },
    {"rett"   ,T_RETT   ,FMT3_OP3_RETT   },
    {"prrd"   ,T_PRRD   ,FMT3_OP3_PRRD   },
    {"prwr"   ,T_PRWR   ,FMT3_OP3_PRWR   },
    {"pilwr"  ,T_PILWR  ,FMT3_OP3_PIL_W  },

    {"lduba"  ,T_FMT3   ,FMT3_OP3_LDUBA  },
    {"lduha"  ,T_FMT3   ,FMT3_OP3_LDUHA  },
    {"lda"    ,T_FMT3   ,FMT3_OP3_LDA    },
    {"ldsba"  ,T_FMT3   ,FMT3_OP3_LDSBA  },
    {"ldsha"  ,T_FMT3   ,FMT3_OP3_LDSHA  },
    {"stba"   ,T_FMT3   ,FMT3_OP3_STBA   },
    {"stha"   ,T_FMT3   ,FMT3_OP3_STHA   },
    {"sta"    ,T_FMT3   ,FMT3_OP3_STA    }
};

int inst_num = sizeof (inst) / sizeof (inst [0]);

struct st_reserved_word synthetic [] = {
    {"mov"    ,T_MOV    ,FMT2_OP3_OR   },

    {"inc"    ,T_INC    ,FMT2_OP3_ADD  },
    {"dec"    ,T_DEC    ,FMT2_OP3_SUB  },

    {"bset"   ,T_BSET   ,FMT2_OP3_OR   },
    {"bclr"   ,T_BCLR   ,FMT2_OP3_ANDN },
    {"btog"   ,T_BTOG   ,FMT2_OP3_XOR  },

    {"ret"    ,T_RET    ,FMT3_OP3_JMPL },

    {"ei"     ,T_EI     ,FMT3_OP3_ET_W },
    {"di"     ,T_DI     ,FMT3_OP3_ET_W },

    {"nop"    ,T_NOP    ,FMT0_OP2_SETHI},

    {"unimp"  ,T_UNIMP  ,3             } /* fmt3 op3 = 000011 */
};

int synthetic_num = sizeof (synthetic) / sizeof (synthetic [0]);

%}

%%

"#".*\n          {   return T_EOL; }
\n               {   return T_EOL; }

"0"[0-7]*        {
                     char *endpr;
                     yylval.d = (int)strtol (yytext, &endpr,  8);
                     return T_IMM;
                 }
[+-]?[1-9][0-9]* {
                     char *endpr;
                     yylval.d = (int)strtol (yytext, &endpr, 10);
                     return T_IMM;
                 }
"0x"[0-9a-fA-F]+ {
                     char *endpr;
                     yylval.d = (int)strtol (yytext, &endpr, 16);
                     return T_IMM;
                 }

"'"."'"          {   
                     yylval.d = yytext[1];
                     return T_IMM;
                 }

"%gp"            {    yylval.d =  1; return T_REGISTER; }
"%ra"            {    yylval.d = 29; return T_REGISTER; }
"%pc"            {    yylval.d = 30; return T_REGISTER; }
"%sp"            {    yylval.d = 31; return T_REGISTER; }
"%"[r]?[0-9]+    {
                      int reg_no;

                      yytext++; yytext++;
                      reg_no = atoi (yytext);
                      if ((reg_no >=  0)
                       && (reg_no <= 31)) {
                          yylval.d = reg_no;
                          return T_REGISTER;
                      }
                      else {
                          fprintf (stderr, "error: %d: register '%%r%d' is out of range.\n", yylineno, reg_no);
                          return T_REGISTER;
                      }
                 }

[a-zA-Z_][a-zA-Z0-9_]*":" {
                               yytext [strlen (yytext)-1] = '\0'; /* delete ':' */
                               yylval.s = yytext;
                               return T_LABEL;
                          }
[a-zA-Z_][a-zA-Z0-9_]*    {
                               int i, cmp;

                               /* search instruction word */
                               for (i = 0; i < inst_num; i++) {
                                   cmp = strcmp (yytext, inst [i].inst);
                                   if (cmp == 0) {
                                       yylval.d = inst [i].opcode;
                                       return inst [i].type;
                                   }
                               }
                               /* search synothetic instruction word */
                               for (i = 0; i < synthetic_num; i++) {
                                   cmp = strcmp (yytext, synthetic [i].inst);
                                   if (cmp == 0) {
                                       yylval.d = synthetic [i].opcode;
                                       return synthetic [i].type;
                                   }
                               }
                               yylval.s = yytext;
                               return T_UNDEFSYM;
                          }

"+"      { return yytext [0]; }
"-"      { return yytext [0]; }
","      { return yytext [0]; }

[ \t]    { /* ignore */ }
.        { return T_UNDEF; }

%%
