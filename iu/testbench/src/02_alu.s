start:
    mov %r1, 0x0
    mov %r2, 0x1

    add %r3, %r1, %r1 # r3 = 0 + 0
    add %r4, %r1, %r2 # r4 = 0 + 1
    add %r5, %r2, %r1 # r5 = 1 + 0
    add %r6, %r2, %r2 # r6 = 1 + 1

    stb  %r3, %r0, 0
    stb  %r4, %r0, 1
    stb  %r5, %r0, 2
    stb  %r6, %r0, 3

    and %r3, %r1, %r1 # r3 = 0 and 0
    and %r4, %r1, %r2 # r4 = 0 and 1
    and %r5, %r2, %r1 # r5 = 1 and 0
    and %r6, %r2, %r2 # r6 = 1 and 1

    stb  %r3, %r0, 0 + 4
    stb  %r4, %r0, 1 + 4
    stb  %r5, %r0, 2 + 4
    stb  %r6, %r0, 3 + 4

    or  %r3, %r1, %r1 # r3 = 0 or 0
    or  %r4, %r1, %r2 # r4 = 0 or 1
    or  %r5, %r2, %r1 # r5 = 1 or 0
    or  %r6, %r2, %r2 # r6 = 1 or 1

    stb  %r3, %r0, 0 + 8
    stb  %r4, %r0, 1 + 8
    stb  %r5, %r0, 2 + 8
    stb  %r6, %r0, 3 + 8

    xor %r3, %r1, %r1 # r3 = 0 xor 0
    xor %r4, %r1, %r2 # r4 = 0 xor 1
    xor %r5, %r2, %r1 # r5 = 1 xor 0
    xor %r6, %r2, %r2 # r6 = 1 xor 1

    stb  %r3, %r0, 0 + 12
    stb  %r4, %r0, 1 + 12
    stb  %r5, %r0, 2 + 12
    stb  %r6, %r0, 3 + 12

    sub %r3, %r1, %r1 # r3 = 0 - 0
    sub %r4, %r1, %r2 # r4 = 0 - 1
    sub %r5, %r2, %r1 # r5 = 1 - 0
    sub %r6, %r2, %r2 # r6 = 1 - 1

    stb  %r3, %r0, 0 + 16
    stb  %r4, %r0, 1 + 16
    stb  %r5, %r0, 2 + 16
    stb  %r6, %r0, 3 + 16

    andn %r3, %r1, %r1 # r3 = 0 andn (not 0)
    andn %r4, %r1, %r2 # r4 = 0 andn (not 1)
    andn %r5, %r2, %r1 # r5 = 1 andn (not 0)
    andn %r6, %r2, %r2 # r6 = 1 andn (not 1)

    stb  %r3, %r0, 0 + 20
    stb  %r4, %r0, 1 + 20
    stb  %r5, %r0, 2 + 20
    stb  %r6, %r0, 3 + 20

    orn %r3, %r1, %r1 # r3 = 0 or (not 0)
    orn %r4, %r1, %r2 # r4 = 0 or (not 1)
    orn %r5, %r2, %r1 # r5 = 1 or (not 0)
    orn %r6, %r2, %r2 # r6 = 1 or (not 1)

    stb  %r3, %r0, 0 + 24
    stb  %r4, %r0, 1 + 24
    stb  %r5, %r0, 2 + 24
    stb  %r6, %r0, 3 + 24

    xnor %r3, %r1, %r1 # r3 = 0 xnor (not 0)
    xnor %r4, %r1, %r2 # r4 = 0 xnor (not 1)
    xnor %r5, %r2, %r1 # r5 = 1 xnor (not 0)
    xnor %r6, %r2, %r2 # r6 = 1 xnor (not 1)

    stb  %r3, %r0, 0 + 28
    stb  %r4, %r0, 1 + 28
    stb  %r5, %r0, 2 + 28
    stb  %r6, %r0, 3 + 28
