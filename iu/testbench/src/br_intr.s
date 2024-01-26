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
    mov %r5,  0
    stb %r5, %r0, 0 + 3
    rett
    call end
interrupt1:
    mov %r5,  1
    stb %r5, %r0, 4 + 3
    rett
    call end
interrupt2:
    mov %r5,  2
    stb %r5, %r0, 8 + 3
    rett
    call end
interrupt3:
    mov %r5,  3
    stb %r5, %r0,12 + 3
    rett
    call end
interrupt4:
    mov %r5,  4
    stb %r5, %r0,16 + 3
    rett
    call end
interrupt5:
    mov %r5,  5
    stb %r5, %r0,20 + 3
    rett
    call end
interrupt6:
    mov %r5,  6
    stb %r5, %r0,24 + 3
    rett
    call end
interrupt7:
    mov %r5,  7
    stb %r5, %r0,28 + 3
    rett
    call end
interrupt8:
    mov %r5,  8
    stb %r5, %r0,32 + 3
    rett
    call end
interrupt9:
    mov %r5,  9
    stb %r5, %r0,36 + 3
    rett
    call end
interrupt10:
    mov %r5, 10
    stb %r5, %r0,40 + 3
    rett
    call end
interrupt11:
    mov %r5, 11
    stb %r5, %r0,44 + 3
    rett
    call end
interrupt12:
    mov %r5, 12
    stb %r5, %r0,48 + 3
    rett
    call end
interrupt13:
    mov %r5, 13
    stb %r5, %r0,52 + 3
    rett
    call end
interrupt14:
    mov %r5, 14
    stb %r5, %r0,56 + 3
    rett
    call end
interrupt15:
    mov %r5, 15
    stb %r5, %r0,60 + 3
    rett
    call end
start:
    ei

    mov %r1, -1
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

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    st  %r0, %r0, 1020

end:
