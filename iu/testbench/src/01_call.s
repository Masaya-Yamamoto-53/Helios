start:
    mov %r1, 0
    call call1
call1:
    inc %r1
    stb %r1, %r0,  0
    call call5
call2:
    inc %r1
    stb %r1, %r0,  4
    call call4
call3:
    inc %r1
    stb %r1, %r0,  8
    call call6
call4:
    inc %r1
    stb %r1, %r0, 12
    call call3
call5:
    inc %r1
    stb %r1, %r0, 16
    call call2
call6:
    inc %r1
    stb %r1, %r0, 20
    call call9
call7:
    inc %r1
    stb %r1, %r0, 24
    call end
call8:
    inc %r1
    stb %r1, %r0, 28
    call call7
call9:
    inc %r1
    stb %r1, %r0, 32
    call call8
end:
