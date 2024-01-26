# Binary Search
    mov %sp, 1024
    mov %gp, 4
start:
    mov %r2, 1
    st  %r2, %gp,  0
    mov %r2, 2
    st  %r2, %gp,  4
    mov %r2, 3
    st  %r2, %gp,  8
    mov %r2, 4
    st  %r2, %gp, 12
    mov %r2, 5
    st  %r2, %gp, 16
    mov %r2, 6
    st  %r2, %gp, 20
    mov %r2, 7
    st  %r2, %gp, 24
    mov %r2, 8
    st  %r2, %gp, 28
    mov %r2, 9
    st  %r2, %gp, 32
    mov %r2, 10
    st  %r2, %gp, 36
    mov %r2, 11
    st  %r2, %gp, 40
    mov %r2, 12
    st  %r2, %gp, 44
    mov %r2, 13
    st  %r2, %gp, 48
    mov %r2, 14
    st  %r2, %gp, 52
    mov %r2, 15
    st  %r2, %gp, 56

    mov %r7, %gp # array
    mov %r8,  13 # key
    mov %r9,   0 # imin
    mov %r10, 14 # imax
    call binarySearch
    stb %r27, %gp, -4

    mov %r8,  1
    call binarySearch
    stb %r27, %gp, -3

    mov %r8,  7
    call binarySearch
    stb %r27, %gp, -2

    mov %r8, 16
    call binarySearch
    stb %r27, %gp, -1

    call end

binarySearch:
    add %sp,  %sp, -28
    st  %r9,  %sp,   0 # imin
    st  %r10, %sp,   4 # imax
    st  %r11, %sp,   8 # cand
    st  %r12, %sp,  12 # add
    st  %r13, %sp,  16 # array_tmp
    st  %r14, %sp,  20 # imid
    st  %ra , %sp,  24

    # if(imax < imin)
    cmplt %r11, %r10, %r9
    brlbc %r11, else_state
        mov %r27, -1
        brlbc %r0, search_end
else_state:
    # int imid = imin + (imax - imin) / 2;
    sub %r14, %r10, %r9 # (imax - imin)
    srl %r14, %r14,   1 # (imax - imin) / 2
    add %r14, %r14, %r9 # imin + (imax - imin) / 2
    # if(array[imid] > key)
    sll %r12, %r14, 2 # 4byte data address
    ld %r13, %gp, %r12
    cmplt %r11, %r8, %r13
    brlbc %r11, else_state2
        sub %r10, %r14, 1
        call binarySearch
        brlbc %r0, search_end
else_state2:
    # if(array[imid] < key)
    cmplt %r11, %r13, %r8
    brlbc %r11, else_state3
        add %r9, %r14, 1
        call binarySearch
        brlbc %r0, search_end
else_state3:
    mov %r27, %r14
    brlbc %r0, search_end
search_end:
    ld  %r9,  %sp,   0 # imin
    ld  %r10, %sp,   4 # imax
    ld  %r11, %sp,   8 # cand
    ld  %r12, %sp,  12 # add
    ld  %r13, %sp,  16 # array_tmp
    ld  %r14, %sp,  20 # imid
    ld  %ra,  %sp,  24
    add %sp,  %sp,  28
    ret
end:
