#ifndef _HAS_OP_H_
#define _HAS_OP_H_

#define FMT0_COND_BRLBC  (0) /* cond = "000" */
#define FMT0_COND_BRZ    (1) /* cond = "001" */
#define FMT0_COND_BRLZ   (2) /* cond = "010" */
#define FMT0_COND_BRLEZ  (3) /* cond = "011" */
#define FMT0_COND_BRLBS  (4) /* cond = "100" */
#define FMT0_COND_BRNZ   (5) /* cond = "101" */
#define FMT0_COND_BRGZ   (6) /* cond = "110" */
#define FMT0_COND_BRGEZ  (7) /* cond = "111" */

#define FMT0_OP2_SETHI   (0) /* op2 = "00" */
#define FMT0_OP2_BR      (1) /* op2 = "01" */
        /* unimp         (2)    op2 = "10" */
        /* unimp         (3)    op2 = "11" */

#define FMT2_OP3_ADD     (0) /* op3 = "000000" */
#define FMT2_OP3_AND     (1) /* op3 = "000001" */
#define FMT2_OP3_OR      (2) /* op3 = "000010" */
#define FMT2_OP3_XOR     (3) /* op3 = "000011" */
#define FMT2_OP3_SUB     (4) /* op3 = "000100" */
#define FMT2_OP3_ANDN    (5) /* op3 = "000101" */
#define FMT2_OP3_ORN     (6) /* op3 = "000110" */
#define FMT2_OP3_XNOR    (7) /* op3 = "000111" */
#define FMT2_OP3_MUL     (8) /* op3 = "001000" */
#define FMT2_OP3_UMULH   (9) /* op3 = "001001" */
        /* unimp        (10)    op3 = "001010" */
        /* unimp        (11)    op3 = "001011" */
        /* unimp        (12)    op3 = "001100" */
        /* unimp        (13)    op3 = "001101" */
        /* unimp        (14)    op3 = "001110" */
        /* unimp        (15)    op3 = "001111" */
        /* unimp        (16)    op3 = "010000" */
#define FMT2_OP3_SLL    (17) /* op3 = "010001" */
#define FMT2_OP3_SRL    (18) /* op3 = "010010" */
#define FMT2_OP3_SRA    (19) /* op3 = "010011" */
#define FMT2_OP3_SEXTB  (20) /* op3 = "010100" */
#define FMT2_OP3_SEXTH  (21) /* op3 = "010101" */
        /* unimp        (22)    op3 = "010110" */
        /* unimp        (23)    op3 = "010111" */
#define FMT2_OP3_CMPEQ  (24) /* op3 = "011000" */
        /* unimp        (25)    op3 = "011001" */
#define FMT2_OP3_CMPLT  (26) /* op3 = "011010" */
#define FMT2_OP3_CMPLE  (27) /* op3 = "011011" */
#define FMT2_OP3_CMPNEQ (28) /* op3 = "011100" */
        /* unimp        (29)    op3 = "011101" */
#define FMT2_OP3_CMPLTU (30) /* op3 = "011110" */
#define FMT2_OP3_CMPLEU (31) /* op3 = "011111" */


#define FMT3_OP3_LDUB    (0) /* op3 = "000000" */
#define FMT3_OP3_LDUH    (1) /* op3 = "000001" */
#define FMT3_OP3_LD      (2) /* op3 = "000010" */
        /* unimp         (3)    op3 = "000011" */
#define FMT3_OP3_LDSB    (4) /* op3 = "000100" */
#define FMT3_OP3_LDSH    (5) /* op3 = "000101" */
        /* unimp         (6)    op3 = "000110" */
        /* unimp         (7)    op3 = "000111" */
#define FMT3_OP3_STB     (8) /* op3 = "001000" */
#define FMT3_OP3_STH     (9) /* op3 = "001001" */
#define FMT3_OP3_ST     (10) /* op3 = "001010" */
        /* unimp        (11)    op3 = "001011" */
        /* unimp        (12)    op3 = "001100" */
        /* unimp        (13)    op3 = "001101" */
        /* unimp        (14)    op3 = "001110" */
        /* unimp        (15)    op3 = "001111" */

#define FMT3_OP3_JMPL   (16) /* op3 = "010000" */
#define FMT3_OP3_RETT   (17) /* op3 = "010001" */
        /* unimp        (18)    op3 = "010010" */
        /* unimp        (19)    op3 = "010011" */
#define FMT3_OP3_PRRD   (20) /* op3 = "010100" */
#define FMT3_OP3_PRWR   (21) /* op3 = "010101" */
#define FMT3_OP3_ET_W   (22) /* op3 = "010110" */
#define FMT3_OP3_PIL_W  (23) /* op3 = "010111" */

        /* unimp        (24)    op3 = "011000" */
        /* unimp        (25)    op3 = "011001" */
        /* unimp        (26)    op3 = "011010" */
        /* unimp        (27)    op3 = "011011" */
        /* unimp        (28)    op3 = "011100" */
        /* unimp        (29)    op3 = "011101" */
        /* unimp        (30)    op3 = "011110" */
        /* unimp        (31)    op3 = "011111" */

#define FMT3_OP3_LDUBA  (32) /* op3 = "100000" */
#define FMT3_OP3_LDUHA  (33) /* op3 = "100001" */
#define FMT3_OP3_LDA    (34) /* op3 = "100010" */
        /* unimp        (35)    op3 = "100011" */
#define FMT3_OP3_LDSBA  (36) /* op3 = "100100" */
#define FMT3_OP3_LDSHA  (37) /* op3 = "100101" */
        /* unimp        (38)    op3 = "100110" */
        /* unimp        (39)    op3 = "100111" */
#define FMT3_OP3_STBA   (40) /* op3 = "101000" */
#define FMT3_OP3_STHA   (41) /* op3 = "101001" */
#define FMT3_OP3_STA    (42) /* op3 = "101010" */
        /* unimp        (43)    op3 = "101011" */
        /* unimp        (44)    op3 = "101100" */
        /* unimp        (45)    op3 = "101101" */
        /* unimp        (46)    op3 = "101110" */
        /* unimp        (47)    op3 = "101111" */

#endif /* _HAS_OP_H_ */
