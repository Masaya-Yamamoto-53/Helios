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
    inc %r1
    mov %r2, 5
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
    prrd %r3
    st  %r3, %r0,    4

    prwr %r3, 0x20
    prrd %r3            # Trap
    st  %r3, %r0,    8
    st  %r1, %r0,   12

    rett                # Trap
    st  %r1, %r0,   16

    lduba %r3, %r0,  0  # trap
    st  %r1, %r0,   20
    lduha %r3, %r0,  0  # trap
    st  %r1, %r0,   24
    ldsba %r3, %r0,  0  # trap
    st  %r1, %r0,   28
    ldsha %r3, %r0,  0  # trap
    st  %r1, %r0,   32
    lda   %r3, %r0,  0  # trap
    st  %r1, %r0,   36

    stba %r1, %r0,   0  # trap
    st  %r1, %r0,   40
    stha %r1, %r0,   0  # trap
    st  %r1, %r0,   44
    sta  %r1, %r0,   0  # trap
    st  %r1, %r0,   48

    st  %r2, %r0,    0
end:
