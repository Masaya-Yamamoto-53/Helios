exception0:
    call start
    nop
    nop
    nop
exception1:
    mov %r1,  1
    stb %r1, %r0, 0
    nop
    rett
exception2:
    mov %r1,  2
    stb %r1, %r0, 0
    nop
    rett
exception3:
    mov %r1,  3
    stb %r1, %r0, 0
    nop
    rett
exception4:
    mov %r1,  4
    stb %r1, %r0, 0
    nop
    rett
exception5:
    mov %r1,  5
    stb %r1, %r0, 0
    nop
    rett
exception6:
    mov %r1,  6
    stb %r1, %r0, 0
    nop
    rett
exception7:
    mov %r1,  7
    stb %r1, %r0, 0
    nop
    rett
exception8:
    mov %r1,  8
    stb %r1, %r0, 0
    nop
    rett
exception9:
    mov %r1,  9
    stb %r1, %r0, 0
    nop
    rett
exception10:
    mov %r1, 10
    stb %r1, %r0, 0
    nop
    rett
exception11:
    mov %r1, 11
    stb %r1, %r0, 0
    nop
    rett
exception12:
    mov %r1, 12
    stb %r1, %r0, 0
    nop
    rett
exception13:
    mov %r1, 13
    stb %r1, %r0, 0
    nop
    rett
exception14:
    mov %r1, 14
    stb %r1, %r0, 0
    nop
    rett
exception15:
    mov %r1, 15
    stb %r1, %r0, 0
    nop
    rett
interrupt0:
    mov %r2,  0
    stb %r2, %r0, 1
    nop
    nop
    nop
interrupt1:
    mov %r2,  1
    stb %r2, %r0, 1
    nop
    rett
interrupt2:
    mov %r2,  2
    stb %r2, %r0, 1
    nop
    rett
interrupt3:
    mov %r2,  3
    stb %r2, %r0, 1
    nop
    rett
interrupt4:
    mov %r2,  4
    stb %r2, %r0, 1
    nop
    rett
interrupt5:
    mov %r2,  5
    stb %r2, %r0, 1
    nop
    rett
interrupt6:
    mov %r2,  6
    stb %r2, %r0, 1
    nop
    rett
interrupt7:
    mov %r2,  7
    stb %r2, %r0, 1
    nop
    rett
interrupt8:
    mov %r2,  8
    stb %r2, %r0, 1
    nop
    rett
interrupt9:
    mov %r2,  9
    stb %r2, %r0, 1
    nop
    rett
interrupt10:
    mov %r2, 10
    stb %r2, %r0, 1
    nop
    rett
interrupt11:
    mov %r2, 11
    stb %r2, %r0, 1
    nop
    rett
interrupt12:
    mov %r2, 12
    stb %r2, %r0, 1
    nop
    rett
interrupt13:
    mov %r2, 13
    stb %r2, %r0, 1
    nop
    rett
interrupt14:
    mov %r2, 14
    stb %r2, %r0, 1
    stb %r3, %r0, 2
    rett
interrupt15:
    mov %r2, 15
    stb %r2, %r0, 1
    nop
    rett
start:
    prwr  %r7, 0xFF
    prrd  %r6
end:
