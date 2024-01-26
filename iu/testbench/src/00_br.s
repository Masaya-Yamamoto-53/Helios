    mov %r1, -3
    mov %r2,  0
    mov %r3,  1

    brlbc %r1, brlbc_token_r1 # false
    mov %r4,  0
    stb %r4, %r0, 0
    brlbc %r0, brlbc_not_token_r1
brlbc_token_r1:
    mov %r4,  1
    stb %r4, %r0, 0
brlbc_not_token_r1:

    brlbc %r2, brlbc_token_r2 # true
    mov %r4,  0
    stb %r4, %r0, 1
    brlbc %r0, brlbc_not_token_r2
brlbc_token_r2:
    mov %r4,  1
    stb %r4, %r0, 1
brlbc_not_token_r2:

    brlbc %r3, brlbc_token_r3 # false
    mov %r4,  0
    stb %r4, %r0, 2
    brlbc %r0, brlbc_not_token_r3
brlbc_token_r3:
    mov %r4,  1
    stb %r4, %r0, 2
brlbc_not_token_r3:

    brz %r1, brz_token_r1 # false
    mov %r4,  0
    stb %r4, %r0, 4
    brlbc %r0, brz_not_token_r1
brz_token_r1:
    mov %r4,  1
    stb %r4, %r0, 4
brz_not_token_r1:

    brz %r2, brz_token_r2 # true
    mov %r4,  0
    stb %r4, %r0, 5
    brlbc %r0, brz_not_token_r2
brz_token_r2:
    mov %r4,  1
    stb %r4, %r0, 5
brz_not_token_r2:

    brz %r3, brz_token_r3 # false
    mov %r4,  0
    stb %r4, %r0, 6
    brlbc %r0, brz_not_token_r3
brz_token_r3:
    mov %r4,  1
    stb %r4, %r0, 6
brz_not_token_r3:

    brlz %r1, brlz_token_r1 # true
    mov %r4,  0
    stb %r4, %r0, 8
    brlbc %r0, brlz_not_token_r1
brlz_token_r1:
    mov %r4,  1
    stb %r4, %r0, 8
brlz_not_token_r1:

    brlz %r2, brlz_token_r2 # false
    mov %r4,  0
    stb %r4, %r0, 9
    brlbc %r0, brlz_not_token_r2
brlz_token_r2:
    mov %r4,  1
    stb %r4, %r0, 9
brlz_not_token_r2:

    brlz %r3, brlz_token_r3 # false
    mov %r4,  0
    stb %r4, %r0, 10
    brlbc %r0, brlz_not_token_r3
brlz_token_r3:
    mov %r4,  1
    stb %r4, %r0, 10
brlz_not_token_r3:

    brlez %r1, brlez_token_r1 # true
    mov %r4,  0
    stb %r4, %r0, 12
    brlbc %r0, brlez_not_token_r1
brlez_token_r1:
    mov %r4,  1
    stb %r4, %r0, 12
brlez_not_token_r1:

    brlez %r2, brlez_token_r2 # true
    mov %r4,  0
    stb %r4, %r0, 13
    brlbc %r0, brlez_not_token_r2
brlez_token_r2:
    mov %r4,  1
    stb %r4, %r0, 13
brlez_not_token_r2:

    brlez %r3, brlez_token_r3 # false
    mov %r4,  0
    stb %r4, %r0, 14
    brlbc %r0, brlez_not_token_r3
brlez_token_r3:
    mov %r4,  1
    stb %r4, %r0, 14
brlez_not_token_r3:

    brlbs %r1, brlbs_token_r1 # true
    mov %r4,  0
    stb %r4, %r0, 16
    brlbc %r0, brlbs_not_token_r1
brlbs_token_r1:
    mov %r4,  1
    stb %r4, %r0, 16
brlbs_not_token_r1:

    brlbs %r2, brlbs_token_r2 # false
    mov %r4,  0
    stb %r4, %r0, 17
    brlbc %r0, brlbs_not_token_r2
brlbs_token_r2:
    mov %r4,  1
    stb %r4, %r0, 17
brlbs_not_token_r2:

    brlbs %r3, brlbs_token_r3 # true
    mov %r4,  0
    stb %r4, %r0, 18
    brlbc %r0, brlbs_not_token_r3
brlbs_token_r3:
    mov %r4,  1
    stb %r4, %r0, 18
brlbs_not_token_r3:

    brnz %r1, brnz_token_r1 # true
    mov %r4,  0
    stb %r4, %r0, 20
    brlbc %r0, brnz_not_token_r1
brnz_token_r1:
    mov %r4,  1
    stb %r4, %r0, 20
brnz_not_token_r1:

    brnz %r2, brnz_token_r2 # false
    mov %r4,  0
    stb %r4, %r0, 21
    brlbc %r0, brnz_not_token_r2
brnz_token_r2:
    mov %r4,  1
    stb %r4, %r0, 21
brnz_not_token_r2:

    brnz %r3, brnz_token_r3 # true
    mov %r4,  0
    stb %r4, %r0, 22
    brlbc %r0, brnz_not_token_r3
brnz_token_r3:
    mov %r4,  1
    stb %r4, %r0, 22
brnz_not_token_r3:

    brgz %r1, brgz_token_r1 # false
    mov %r4,  0
    stb %r4, %r0, 24
    brlbc %r0, brgz_not_token_r1
brgz_token_r1:
    mov %r4,  1
    stb %r4, %r0, 24
brgz_not_token_r1:

    brgz %r2, brgz_token_r2 # false
    mov %r4,  0
    stb %r4, %r0, 25
    brlbc %r0, brgz_not_token_r2
brgz_token_r2:
    mov %r4,  1
    stb %r4, %r0, 25
brgz_not_token_r2:

    brgz %r3, brgz_token_r3 # true
    mov %r4,  0
    stb %r4, %r0, 26
    brlbc %r0, brgz_not_token_r3
brgz_token_r3:
    mov %r4,  1
    stb %r4, %r0, 26
brgz_not_token_r3:

    brgez %r1, brgez_token_r1 # false
    mov %r4,  0
    stb %r4, %r0, 28
    brlbc %r0, brgez_not_token_r1
brgez_token_r1:
    mov %r4,  1
    stb %r4, %r0, 28
brgez_not_token_r1:

    brgez %r2, brgez_token_r2 # true
    mov %r4,  0
    stb %r4, %r0, 29
    brlbc %r0, brgez_not_token_r2
brgez_token_r2:
    mov %r4,  1
    stb %r4, %r0, 29
brgez_not_token_r2:

    brgez %r3, brgez_token_r3 # true
    mov %r4,  0
    stb %r4, %r0, 30
    brlbc %r0, brgez_not_token_r3
brgez_token_r3:
    mov %r4,  1
    stb %r4, %r0, 30
brgez_not_token_r3:
