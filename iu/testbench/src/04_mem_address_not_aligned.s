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
    inc %r1
    mov %r2, 9
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
    sth  %r0, %r0,  1
    st   %r1, %r0,  4

    sth  %r0, %r0,  3
    st   %r1, %r0,  8

    st   %r0, %r0,  1
    st   %r1, %r0, 12

    st   %r0, %r0,  2
    st   %r1, %r0, 16

    st   %r0, %r0,  3
    st   %r1, %r0, 20

    lduh %r0, %r0,  1
    st   %r1, %r0, 24

    lduh %r0, %r0,  3
    st   %r1, %r0, 28

    ldsh %r0, %r0,  1
    st   %r1, %r0, 32

    ldsh %r0, %r0,  3
    st   %r1, %r0, 36

    ld   %r0, %r0,  1
    st   %r1, %r0, 40

    ld   %r0, %r0,  2
    st   %r1, %r0, 44

    ld   %r0, %r0,  3
    st   %r1, %r0, 48

    nop
    jmpl %ra, %pc,  1
    st   %r1, %r0, 52

    jmpl %ra, %pc,  2
    st   %r1, %r0, 56

    jmpl %ra, %pc,  3
    st   %r1, %r0, 60

    st   %r2, %r0,  0
