exception0:
    mov %sp, 1024
    mov %gp, 0
    st  %r0, %r0, 0
    call start
exception1:
    mov %r1,  1
    st  %r1, %r0, 0
    nop
    rett
exception2:
    mov %r1,  2
    st  %r1, %r0, 0
    nop
    rett
exception3:
    mov %r1,  3
    st  %r1, %r0, 0
    nop
    rett
exception4:
    mov %r1,  4
    st  %r1, %r0, 0
    nop
    rett
exception5:
    mov %r1,  5
    st  %r1, %r0, 0
    nop
    rett
exception6:
    mov %r1,  6
    st  %r1, %r0, 0
    nop
    rett
exception7:
    mov %r1,  7
    st  %r1, %r0, 0
    nop
    rett
exception8:
    mov %r1,  8
    st  %r1, %r0, 0
    nop
    rett
exception9:
    mov %r1,  9
    st  %r1, %r0, 0
    nop
    rett
exception10:
    mov %r1, 10
    st  %r1, %r0, 0
    nop
    rett
exception11:
    mov %r1, 11
    st  %r1, %r0, 0
    nop
    rett
exception12:
    mov %r1, 12
    st  %r1, %r0, 0
    nop
    rett
exception13:
    mov %r1, 13
    st  %r1, %r0, 0
    nop
    rett
exception14:
    mov %r1, 14
    st  %r1, %r0, 0
    nop
    rett
exception15:
    mov %r1, 15
    st  %r1, %r0, 0
    nop
    rett
interrupt0:
    mov %r16,  0
    stb %r16, %r0, 216 + 3
    rett
    call end
interrupt1:
    mov %r16,  1
    stb %r16, %r0, 220 + 3
    rett
    call end
interrupt2:
    mov %r16,  2
    stb %r16, %r0, 224 + 3
    rett
    call end
interrupt3:
    mov %r16,  3
    stb %r16, %r0, 228 + 3
    rett
    call end
interrupt4:
    mov %r16,  4
    stb %r16, %r0, 232 + 3
    rett
    call end
interrupt5:
    mov %r16,  5
    stb %r16, %r0, 236 + 3
    rett
    call end
interrupt6:
    mov %r16,  6
    stb %r16, %r0, 240 + 3
    rett
    call end
interrupt7:
    mov %r16,  7
    stb %r16, %r0, 244 + 3
    rett
    call end
interrupt8:
    mov %r16,  8
    stb %r16, %r0, 248 + 3
    rett
    call end
interrupt9:
    mov %r16,  9
    stb %r16, %r0, 252 + 3
    rett
    call end
interrupt10:
    mov %r16, 10
    stb %r16, %r0, 256 + 3
    rett
    call end
interrupt11:
    mov %r16, 11
    stb %r16, %r0, 260 + 3
    rett
    call end
interrupt12:
    mov %r16, 12
    stb %r16, %r0, 264 + 3
    rett
    call end
interrupt13:
    mov %r16, 13
    stb %r16, %r0, 268 + 3
    rett
    call end
interrupt14:
    mov %r16, 14
    stb %r16, %r0, 272 + 3
    rett
    call end
interrupt15:
    mov %r16, 15
    stb %r16, %r0, 276 + 3
    rett
    call end
start:
    ei

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

end:
