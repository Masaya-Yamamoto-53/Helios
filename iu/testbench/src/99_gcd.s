# Euclidean Algorithm
    mov %sp, 1024
    mov %r11,  0
    mov %r12,  0
start:
    mov %r7, 1071
    mov %r8, 1029
    call gcd
    stb %r27, %r0, 0 # ans=21

    mov %r7, 168
    mov %r8, 180
    call gcd
    stb %r27, %r0, 1 # ans=12

    mov %r7, 42
    mov %r8, 60
    call gcd
    stb %r27, %r0, 2 # ans=6

    mov %r7, 3355
    mov %r8, 2379
    call gcd
    stb %r27, %r0, 3 # ans=61

    call end

gcd:
    add %sp,  %sp, -16
    st  %r7,  %sp,   0
    st  %r8,  %sp,   4
    st  %r11, %sp,   8
    st  %r12, %sp,  12
gcd_loop:
    cmpneq %r11, %r7, %r8
    brlbc %r11, gcd_end

    cmplt %r12, %r8, %r7
    brlbc %r12, gcd_else
gcd_if:
    sub %r7, %r7, %r8
    brlbc %r0, gcd_endif
gcd_else: 
    sub %r8, %r8, %r7
gcd_endif:
    brlbc %r0, gcd_loop
gcd_end:
    mov %r27, %r7

    ld  %r7,  %sp,  0
    ld  %r8,  %sp,  4
    ld  %r11, %sp,  8
    ld  %r12, %sp, 12
    add %sp,  %sp, 16
    ret

end:
