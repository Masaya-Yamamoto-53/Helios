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
    mov %r10,  0
    stb %r10, %r0, 0 + 3
    rett
    call end
interrupt1:
    mov %r10,  1
    stb %r10, %r0, 4 + 3
    rett
    call end
interrupt2:
    mov %r10,  2
    stb %r10, %r0, 8 + 3
    rett
    call end
interrupt3:
    mov %r10,  3
    stb %r10, %r0,12 + 3
    rett
    call end
interrupt4:
    mov %r10,  4
    stb %r10, %r0,16 + 3
    rett
    call end
interrupt5:
    mov %r10,  5
    stb %r10, %r0,20 + 3
    rett
    call end
interrupt6:
    mov %r10,  6
    stb %r10, %r0,24 + 3
    rett
    call end
interrupt7:
    mov %r10,  7
    stb %r10, %r0,28 + 3
    rett
    call end
interrupt8:
    mov %r10,  8
    stb %r10, %r0,32 + 3
    rett
    call end
interrupt9:
    mov %r10,  9
    stb %r10, %r0,36 + 3
    rett
    call end
interrupt10:
    mov %r10, 10
    stb %r10, %r0,40 + 3
    rett
    call end
interrupt11:
    mov %r10, 11
    stb %r10, %r0,44 + 3
    rett
    call end
interrupt12:
    mov %r10, 12
    stb %r10, %r0,48 + 3
    rett
    call end
interrupt13:
    mov %r10, 13
    stb %r10, %r0,52 + 3
    rett
    call end
interrupt14:
    mov %r10, 14
    stb %r10, %r0,56 + 3
    rett
    call end
interrupt15:
    mov %r10, 15
    stb %r10, %r0,60 + 3
    rett
    call end
start:
    ei

    mov %r1, 1
    mov %r2, 2
    mov %r3, 3
    mov %r4, 4
    mov %r5, 5
    mov %r6, 6
    mov %r7, 7
    mov %r8, 8
    mov %r9, 9
    call call1
call1:
    stb %r1, %r0,  0
    call call5
call2:
    stb  %r3, %r0,  8
    call call4
call3:
    stb  %r5, %r0, 16
    call call6
call4:
    stb  %r4, %r0, 12
    call call3
call5:
    stb  %r2, %r0,  4
    call call2
call6:
    stb  %r6, %r0, 20
    call call9
call7:
    stb  %r9, %r0, 32
    call end
call8:
    stb  %r8, %r0, 28
    call call7
call9:
    stb  %r7, %r0, 24
    call call8
end:
