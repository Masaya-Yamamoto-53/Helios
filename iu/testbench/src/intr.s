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
    mov %r2,  0
    st  %r2, %r0, 0
    rett
    call end
interrupt1:
    mov %r2,  1
    st  %r2, %r0, 4
    rett
    call end
interrupt2:
    mov %r2,  2
    st  %r2, %r0, 8
    rett
    call end
interrupt3:
    mov %r2,  3
    st  %r2, %r0,12
    rett
    call end
interrupt4:
    mov %r2,  4
    st  %r2, %r0,16
    rett
    call end
interrupt5:
    mov %r2,  5
    st  %r2, %r0,20
    rett
    call end
interrupt6:
    mov %r2,  6
    st  %r2, %r0,24
    rett
    call end
interrupt7:
    mov %r2,  7
    st  %r2, %r0,28
    rett
    call end
interrupt8:
    mov %r2,  8
    st  %r2, %r0,32
    rett
    call end
interrupt9:
    mov %r2,  9
    st  %r2, %r0,36
    rett
    call end
interrupt10:
    mov %r2, 10
    st  %r2, %r0,40
    rett
    call end
interrupt11:
    mov %r2, 11
    st  %r2, %r0,44
    rett
    call end
interrupt12:
    mov %r2, 12
    st  %r2, %r0,48
    rett
    call end
interrupt13:
    mov %r2, 13
    st  %r2, %r0,52
    rett
    call end
interrupt14:
    mov %r2, 14
    st  %r2, %r0,56
    rett
    call end
interrupt15:
    mov %r2, 15
    st  %r2, %r0,60
    rett
    call end
start:
    ei
end:
    mov %r1, 1
    stb %r1, %r0, 68
    stb %r1, %r0, 69
    stb %r1, %r0, 70
    stb %r1, %r0, 71
    mov %r1, 2
    stb %r1, %r0, 72
    stb %r1, %r0, 73
    stb %r1, %r0, 74
    stb %r1, %r0, 75
    mov %r1, 3
    stb %r1, %r0, 76
    stb %r1, %r0, 77
    stb %r1, %r0, 78
    stb %r1, %r0, 79
    mov %r1, 4
    stb %r1, %r0, 80
    stb %r1, %r0, 81
    stb %r1, %r0, 82
    stb %r1, %r0, 83
    mov %r1, 5
    stb %r1, %r0, 84
    stb %r1, %r0, 85
    stb %r1, %r0, 86
    stb %r1, %r0, 87
    mov %r1, 6
    stb %r1, %r0, 88
    stb %r1, %r0, 89
    stb %r1, %r0, 90
    stb %r1, %r0, 91
    mov %r1, 7
    stb %r1, %r0, 92
    stb %r1, %r0, 93
    stb %r1, %r0, 94
    stb %r1, %r0, 95
    mov %r1, 8
    stb %r1, %r0, 96
    stb %r1, %r0, 97
    stb %r1, %r0, 98
    stb %r1, %r0, 99
    mov %r1, 9
    stb %r1, %r0, 100
    stb %r1, %r0, 101
    stb %r1, %r0, 102
    stb %r1, %r0, 103
    mov %r1, 10
    stb %r1, %r0, 104
    stb %r1, %r0, 105
    stb %r1, %r0, 106
    stb %r1, %r0, 107
    mov %r1, 11
    stb %r1, %r0, 108
    stb %r1, %r0, 109
    stb %r1, %r0, 110
    stb %r1, %r0, 111
    mov %r1, 12
    stb %r1, %r0, 112
    stb %r1, %r0, 113
    stb %r1, %r0, 114
    stb %r1, %r0, 115
    mov %r1, 13
    stb %r1, %r0, 116
    stb %r1, %r0, 117
    stb %r1, %r0, 118
    stb %r1, %r0, 119
    mov %r1, 14
    stb %r1, %r0, 120
    stb %r1, %r0, 121
    stb %r1, %r0, 122
    stb %r1, %r0, 123
    mov %r1, 15
    stb %r1, %r0, 124
    stb %r1, %r0, 125
    stb %r1, %r0, 126
    stb %r1, %r0, 127
    mov %r3, -1
    st  %r3, %r0,  64
    st  %r3, %r0, 128

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    st  %r0, %r0, 1020
