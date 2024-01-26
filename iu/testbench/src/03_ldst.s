start:
    mov %r1, 0x80C0E0F0
    mov %r2, 0x7F3F1F0F

    st %r1, %r0, 0
    st %r2, %r0, 4

    ldub %r3  ,%r0, 0
    ldub %r4  ,%r0, 1
    ldub %r5  ,%r0, 2
    ldub %r6  ,%r0, 3
    lduh %r7  ,%r0, 0
    lduh %r8  ,%r0, 2
    ld   %r9  ,%r0, 0
    ldsb %r10 ,%r0, 0
    ldsb %r11 ,%r0, 1
    ldsb %r12 ,%r0, 2
    ldsb %r13 ,%r0, 3
    ldsh %r14 ,%r0, 0
    ldsh %r15 ,%r0, 2

    st %r3  ,%r0,  8
    st %r4  ,%r0, 12
    st %r5  ,%r0, 16
    st %r6  ,%r0, 20
    st %r7  ,%r0, 24
    st %r8  ,%r0, 28
    st %r9  ,%r0, 32
    st %r10 ,%r0, 36
    st %r11 ,%r0, 40
    st %r12 ,%r0, 44
    st %r13 ,%r0, 48
    st %r14 ,%r0, 52
    st %r15 ,%r0, 56

    ldub %r3  ,%r0, 4
    ldub %r4  ,%r0, 5
    ldub %r5  ,%r0, 6
    ldub %r6  ,%r0, 7
    lduh %r7  ,%r0, 4
    lduh %r8  ,%r0, 6
    ld   %r9  ,%r0, 4
    ldsb %r10 ,%r0, 4
    ldsb %r11 ,%r0, 5
    ldsb %r12 ,%r0, 6
    ldsb %r13 ,%r0, 7
    ldsh %r14 ,%r0, 4
    ldsh %r15 ,%r0, 6

    st %r3  ,%r0,  60
    st %r4  ,%r0,  64
    st %r5  ,%r0,  68
    st %r6  ,%r0,  72
    st %r7  ,%r0,  76
    st %r8  ,%r0,  80
    st %r9  ,%r0,  84
    st %r10 ,%r0,  88
    st %r11 ,%r0,  92
    st %r12 ,%r0,  96
    st %r13 ,%r0, 100
    st %r14 ,%r0, 104
    st %r15 ,%r0, 108

    lduba %r3  ,%r0, 0
    lduba %r4  ,%r0, 1
    lduba %r5  ,%r0, 2
    lduba %r6  ,%r0, 3
    lduha %r7  ,%r0, 0
    lduha %r8  ,%r0, 2
    lda   %r9  ,%r0, 0
    ldsba %r10 ,%r0, 0
    ldsba %r11 ,%r0, 1
    ldsba %r12 ,%r0, 2
    ldsba %r13 ,%r0, 3
    ldsha %r14 ,%r0, 0
    ldsha %r15 ,%r0, 2

    sta %r3  ,%r0,  8 + 108
    sta %r4  ,%r0, 12 + 108
    sta %r5  ,%r0, 16 + 108
    sta %r6  ,%r0, 20 + 108
    sta %r7  ,%r0, 24 + 108
    sta %r8  ,%r0, 28 + 108
    sta %r9  ,%r0, 32 + 108
    sta %r10 ,%r0, 36 + 108
    sta %r11 ,%r0, 40 + 108
    sta %r12 ,%r0, 44 + 108
    sta %r13 ,%r0, 48 + 108
    sta %r14 ,%r0, 52 + 108
    sta %r15 ,%r0, 56 + 108

    lduba %r3  ,%r0, 4
    lduba %r4  ,%r0, 5
    lduba %r5  ,%r0, 6
    lduba %r6  ,%r0, 7
    lduha %r7  ,%r0, 4
    lduha %r8  ,%r0, 6
    lda   %r9  ,%r0, 4
    ldsba %r10 ,%r0, 4
    ldsba %r11 ,%r0, 5
    ldsba %r12 ,%r0, 6
    ldsba %r13 ,%r0, 7
    ldsha %r14 ,%r0, 4
    ldsha %r15 ,%r0, 6

    sta %r3  ,%r0,  60 + 108
    sta %r4  ,%r0,  64 + 108
    sta %r5  ,%r0,  68 + 108
    sta %r6  ,%r0,  72 + 108
    sta %r7  ,%r0,  76 + 108
    sta %r8  ,%r0,  80 + 108
    sta %r9  ,%r0,  84 + 108
    sta %r10 ,%r0,  88 + 108
    sta %r11 ,%r0,  92 + 108
    sta %r12 ,%r0,  96 + 108
    sta %r13 ,%r0, 100 + 108
    sta %r14 ,%r0, 104 + 108
    sta %r15 ,%r0, 108 + 108
