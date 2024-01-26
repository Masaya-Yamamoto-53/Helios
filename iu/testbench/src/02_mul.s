start:
    call main

# dst %r15, %r14, src1 %r12, src2 %r13
calc_unsigned_mul_64bit:
    umulh %r15, %r12, %r13
    mul   %r14, %r12, %r13
    ret

# dst %r15, %r14, src1 %r12, src2 %r13
# %r12: Ra
# %r13: Rb
calc_signed_mul_64bit:
    umulh %r15, %r12, %r13
    mul   %r14, %r12, %r13

    srl %r10, %r12, 31   # Ra<31>
    mul %r10, %r10, %r13 # Ra<31> x Rb
    srl %r11, %r13, 31   # Rb<31>
    mul %r11, %r11, %r12 # Rb<31> x Ra

    sub %r15, %r15, %r10
    sub %r15, %r15, %r11
    ret

main:
    mov %r12, 0x80000000 # -2.147,483,648
    mov %r13, 0x80000000 # -2.147,483,648
    call calc_signed_mul_64bit
    st %r15, %r0, 0
    st %r14, %r0, 4

    mov %r12, 0xFFFFFFFF # -1
    mov %r13, 0xFFFFFFFF # -1
    call calc_signed_mul_64bit
    st %r15, %r0, 8
    st %r14, %r0, 12
 
    mov %r12, 0x00000000 #  0
    mov %r13, 0x00000000 #  0
    call calc_signed_mul_64bit
    st %r15, %r0, 16
    st %r14, %r0, 20

    mov %r12, 0x00000001 #  1
    mov %r13, 0x00000001 #  1
    call calc_signed_mul_64bit
    st %r15, %r0, 24
    st %r14, %r0, 28

    mov %r12, 0x7FFFFFFF #  2,147,483,647
    mov %r13, 0x7FFFFFFF #  2,147,483,647
    call calc_signed_mul_64bit
    st %r15, %r0, 32
    st %r14, %r0, 36

    mov %r12, 0x80000000 # -2,147,483,648
    mov %r13, 0x7FFFFFFF #  2,147,483,647
    call calc_signed_mul_64bit
    st %r15, %r0, 40
    st %r14, %r0, 44

    mov %r12, 0x7FFFFFFF #  2,147,483,647
    mov %r13, 0x80000000 # -2,147,483,648
    call calc_signed_mul_64bit
    st %r15, %r0, 48
    st %r14, %r0, 52

    mov %r12, 0x80000000 # -2.147,483,648
    mov %r13, 0x80000000 # -2.147,483,648
    call calc_unsigned_mul_64bit
    st %r15, %r0, 56
    st %r14, %r0, 60

    mov %r12, 0xFFFFFFFF # -1
    mov %r13, 0xFFFFFFFF # -1
    call calc_unsigned_mul_64bit
    st %r15, %r0, 64
    st %r14, %r0, 68
 
    mov %r12, 0x00000000 #  0
    mov %r13, 0x00000000 #  0
    call calc_unsigned_mul_64bit
    st %r15, %r0, 72
    st %r14, %r0, 76

    mov %r12, 0x00000001 #  1
    mov %r13, 0x00000001 #  1
    call calc_unsigned_mul_64bit
    st %r15, %r0, 80
    st %r14, %r0, 84

    mov %r12, 0x7FFFFFFF #  2,147,483,647
    mov %r13, 0x7FFFFFFF #  2,147,483,647
    call calc_unsigned_mul_64bit
    st %r15, %r0, 88
    st %r14, %r0, 92

    mov %r12, 0x80000000 # -2,147,483,648
    mov %r13, 0x7FFFFFFF #  2,147,483,647
    call calc_unsigned_mul_64bit
    st %r15, %r0, 96
    st %r14, %r0, 100

    mov %r12, 0x7FFFFFFF #  2,147,483,647
    mov %r13, 0x80000000 # -2,147,483,648
    call calc_unsigned_mul_64bit
    st %r15, %r0, 104
    st %r14, %r0, 108

    mov %r12, 2
    mul %r12, %r12, %r12
    mul %r12, %r12, %r12
    st %r12, %r0, 112
