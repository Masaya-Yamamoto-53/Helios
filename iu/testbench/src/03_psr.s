exception0:
    mov %sp, 1024
    mov %gp, 0
    nop
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
    prrd  %r6          # psr = 101111
    st    %r6, %r0,  0

    ei                 # psr = 111111
    prrd  %r6
    di
    prrd  %r7          # psr = 101111

    st    %r6, %r0,  4
    st    %r7, %r0,  8

    pilwr %r7, 0x3E    # psr = 100001
    prrd  %r6
    pilwr %r6, 0x3C    # psr = 101101
    prrd  %r7

    st    %r6, %r0, 12
    st    %r7, %r0, 16

    prwr  %r7, 0xFF
    prrd  %r6
    st    %r6, %r0, 20
end:
