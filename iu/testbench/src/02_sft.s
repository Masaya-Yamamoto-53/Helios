start:
    mov %r1, 0x80000001 # 1000 0000 0000 0000 0000 0000 0000 0001
    mov %r2, 1 # Shift counter number

    sll %r3, %r1, 1   # 0000 0000 0000 0000 0000 0000 0000 0010
    srl %r4, %r1, 1   # 0100 0000 0000 0000 0000 0000 0000 0000
    sra %r5, %r1, 1   # 1100 0000 0000 0000 0000 0000 0000 0000

    st  %r3, %r0,  0
    st  %r4, %r0,  4
    st  %r5, %r0,  8

    sll %r3, %r1, %r2 # 0000 0000 0000 0000 0000 0000 0000 0010
    srl %r4, %r1, %r2 # 0100 0000 0000 0000 0000 0000 0000 0000
    sra %r5, %r1, %r2 # 1100 0000 0000 0000 0000 0000 0000 0000

    st  %r3, %r0,  0 + 12
    st  %r4, %r0,  4 + 12
    st  %r5, %r0,  8 + 12
