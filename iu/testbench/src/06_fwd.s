# Forwarding Unit Test Case
start:
    mov %r1, 1 # wb0
    mov %r2, 2 # wb1
    mov %r3, 3 # ma0
    mov %r4, 4 # ma1
    mov %r5, 5 # ex0
    mov %r6, 6 # ex1
    add %r7, %r1, %r2 # result=3
    add %r8, %r2, %r1 # result=3
    st %r7, %r0,  0
    st %r8, %r0,  4

    mov %r1, 2 # wb0
    mov %r2, 3 # wb1
    mov %r3, 4 # ma0
    mov %r4, 5 # ma1
    mov %r5, 6 # ex0
    mov %r6, 7 # ex1
    add %r7, %r3, %r4 # result=9
    add %r8, %r4, %r3 # result=9
    st %r7, %r0,  8
    st %r8, %r0, 12

    mov %r1, 3 # wb0
    mov %r2, 4 # wb1
    mov %r3, 5 # ma0
    mov %r4, 6 # ma1
    mov %r5, 7 # ex0
    mov %r6, 8 # ex1
    add %r7, %r5, %r6 # result=15
    add %r8, %r6, %r5 # result=15
    st %r7, %r0, 16
    st %r8, %r0, 20

    mov %r1, 1 # wb0 # --+
    mov %r2, 2 # wb1 # --|-+
    nop #                | |
    nop #                | |
    mov %r1, 5 # ex0 # --+ |
    mov %r2, 6 # ex1 # ----+
    add %r7, %r1, %r2 # result=11
    add %r8, %r2, %r1 # result=11
    st %r7, %r0, 24
    st %r8, %r0, 28

    mov %r1, 2 # wb0 #
    mov %r2, 3 # wb1 #
    mov %r1, 4 # ma0 # --+
    mov %r2, 5 # ma1 # --|-+ 
    mov %r1, 6 # ex0 # --+ |
    mov %r2, 7 # ex1 # ----+
    add %r7, %r1, %r2 # result=13
    add %r8, %r2, %r1 # result=13
    st %r7, %r0, 32
    st %r8, %r0, 36

    mov %r1, 3 # wb0 # --+
    mov %r2, 4 # wb1 # --|-+ 
    mov %r1, 5 # ma0 # --+ |
    mov %r2, 6 # ma1 # ----+
    nop
    nop
    add %r7, %r1, %r2 # result=11
    add %r8, %r2, %r1 # result=11
    st %r7, %r0, 40
    st %r8, %r0, 44

    mov %r2, 2 # wb0 # --+
    mov %r1, 3 # wb1 # --|-+
    nop #                | |
    nop #                | |
    mov %r1, 6 # ex0 # --+ |
    mov %r2, 7 # ex1 # ----+
    add %r7, %r1, %r2 # result=13
    add %r8, %r2, %r1 # result=13
    st %r7, %r0, 48 
    st %r8, %r0, 52

    mov %r1, 3 # wb0 #
    mov %r2, 4 # wb1 #
    mov %r2, 5 # ma0 # --+
    mov %r1, 6 # ma1 # --|-+ 
    mov %r1, 7 # ex0 # --+ |
    mov %r2, 8 # ex1 # ----+
    add %r7, %r1, %r2 # result=15
    add %r8, %r2, %r1 # result=15
    st %r7, %r0, 56 
    st %r8, %r0, 60

    mov %r2, 4 # wb0 # --+
    mov %r1, 5 # wb1 # --|-+ 
    mov %r1, 6 # ma0 # --+ |
    mov %r2, 7 # ma1 # ----+
    nop
    nop
    add %r7, %r1, %r2 # result=13
    add %r8, %r2, %r1 # result=13
    st %r7, %r0, 64 
    st %r8, %r0, 68
