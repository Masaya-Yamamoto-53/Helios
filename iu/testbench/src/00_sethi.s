start:
    nop
    sethi %r1,       0 # 00000000 00000000 00000000 00000000
    sethi %r2,       1 # 00000000 00000000 00000010 00000000
    mov   %r3,   -4097 # 11111111 11111111 11101111 11111111
    mov   %r4,    4096 # 00000000 00000000 00010000 00000000
    mov   %r5,    6144 # 00000000 00000000 00011000 00000000
    sethi %r6, 4194304 # 10000000 00000000 00000000 00000000
    st %r1, %r0,  0
    st %r2, %r0,  4
    st %r3, %r0,  8
    st %r4, %r0, 12
    st %r5, %r0, 16
    st %r6, %r0, 20