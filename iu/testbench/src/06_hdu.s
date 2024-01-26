exception0:
    mov %sp, 1024
    mov %gp, 0
    mov %r1, 0
    call start
exception1:
    nop
    nop
    nop
    rett
exception2:
    nop
    nop
    nop
    rett
exception3:
    nop
    nop
    nop
    rett
exception4:
    nop
    nop
    nop
    rett
exception5: # privileged_instruction
    nop
    nop
    nop
    rett
exception6: # illegal instruction
    nop
    nop
    nop
    rett
exception7:
    nop
    nop
    nop
    rett
exception8:
    nop
    nop
    nop
    rett
exception9: # mem address not aligned
    nop
    nop
    nop
    rett
exception10:
    nop
    nop
    nop
    rett
exception11:
    nop
    nop
    nop
    rett
exception12:
    nop
    nop
    nop
    rett
exception13:
    nop
    nop
    nop
    rett
exception14:
    nop
    nop
    nop
    rett
exception15:
    nop
    nop
    nop
    rett
interrupt0:
    nop
    nop
    nop
    rett
interrupt1:
    nop
    nop
    nop
    rett
interrupt2:
    nop
    nop
    nop
    rett
interrupt3:
    nop
    nop
    nop
    rett
interrupt4:
    nop
    nop
    nop
    rett
interrupt5:
    nop
    nop
    nop
    rett
interrupt6:
    nop
    nop
    nop
    rett
interrupt7:
    nop
    nop
    nop
    rett
interrupt8:
    nop
    nop
    nop
    rett
interrupt9:
    nop
    nop
    nop
    rett
interrupt10:
    nop
    nop
    nop
    rett
interrupt11:
    nop
    nop
    nop
    rett
interrupt12:
    nop
    nop
    nop
    rett
interrupt13:
    nop
    nop
    nop
    rett
interrupt14:
    nop
    nop
    nop
    rett
interrupt15:
    nop
    nop
    nop
    rett
start:
    mov  %r1, 1
    mov  %r2, 5

    # iuhdu_id_read_in
    st   %r1, %r0,  0
    ld   %r3, %r0,  0
    st   %r3, %r0,  4

    # iuhdu_id_read_in
    prrd %r4
    st   %r4, %r0,  8

    # iuhdu_id_read_in
    mul  %r5, %r1, %r2
    st   %r5, %r0, 12

    # iuhdu_ex_branch_in (way0)
    brlbc %r0, brlbs_not_token1
    stb  %r5, %r0, 16
    stb  %r5, %r0, 17
    stb  %r5, %r0, 18
    stb  %r5, %r0, 19
brlbs_not_token1:
    # iuhdu_ex_branch_in (way1)
    brlbc %r0, brlbs_not_token2
    stb  %r5, %r0, 20
    stb  %r5, %r0, 21
    stb  %r5, %r0, 22
    stb  %r5, %r0, 23
brlbs_not_token2:

    # iuhdu_fifo_full_in
    stb  %r5, %r0, 24
    stb  %r5, %r0, 25
    stb  %r5, %r0, 26
    stb  %r5, %r0, 27
    stb  %r5, %r0, 28
    stb  %r5, %r0, 29
    stb  %r5, %r0, 30
    stb  %r5, %r0, 31
