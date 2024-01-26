# bubble sort

# signed char i;
# signed char j;
# signed char tmp;
# signed char array [15] = {9,12,8,10,13,2,5,14,4,6,11,1,7,3,15};

# for (i = 0; i < 15-1; i++) {
#     for (j = 1+i; j < 15; j++) {
#         if (array [i] > array [j]) {
#             tmp = array [i];
#             array [i] = array [j];
#             array [j] = tmp;
#         }
#     }
# }
start:
    mov %sp, 1024
    mov %gp,    0

    # signed char array [15] = {9,12,8,10,13,2,5,14,4,6,11,1,7,3,15};
    mov %r2, 9
    st  %r2, %gp,  0
    mov %r2, 12
    st  %r2, %gp,  4
    mov %r2, 8
    st  %r2, %gp,  8
    mov %r2, 10
    st  %r2, %gp, 12
    mov %r2, 13
    st  %r2, %gp, 16
    mov %r2, 2
    st  %r2, %gp, 20
    mov %r2, 5
    st  %r2, %gp, 24
    mov %r2, 14
    st  %r2, %gp, 28
    mov %r2, 4
    st  %r2, %gp, 32
    mov %r2, 6
    st  %r2, %gp, 36
    mov %r2, 11
    st  %r2, %gp, 40
    mov %r2, 1
    st  %r2, %gp, 44
    mov %r2, 7
    st  %r2, %gp, 48
    mov %r2, 3
    st  %r2, %gp, 52
    mov %r2, 15
    st  %r2, %gp, 56

    mov %r7, %gp
    mov %r8, 15
    call bubbleSort
    call end

bubbleSort:
    add %sp,  %sp, -32
    st  %r11, %sp,   0 # i
    st  %r12, %sp,   4 # j
    st  %r13, %sp,   8 # imax
    st  %r14, %sp,  12 # cond
    st  %r15, %sp,  16 # iaddr
    st  %r16, %sp,  20 # jaddr
    st  %r17, %sp,  24 # ielem
    st  %r18, %sp,  28 # jelem

    # for (i = 0; i < 9; i++)
    mov %r11, 0
    sub %r13, %r8, 1
iloop_return:
    cmplt %r14, %r11, %r13
    brlbc %r14, iloop_end

    # for (j = i+j; j < 10; j++)
    add %r12, %r11, 1
jloop_return:
    cmplt %r14, %r12, %r8
    brlbc %r14, jloop_end

    sll %r15, %r11, 2
    sll %r16, %r12, 2
    ld  %r17, %r7, %r15 # array [i]
    ld  %r18, %r7, %r16 # array [j]

    cmplt %r14, %r17, %r18 # array [i] < array [j]
    brlbs %r14, swap_end
    st  %r17, %r7, %r16
    st  %r18, %r7, %r15
swap_end:
    inc %r12
    brlbc %r0, jloop_return
jloop_end:
    inc %r11
    brlbc %r0, iloop_return
iloop_end:
    ld  %r11, %sp,   0 # i
    ld  %r12, %sp,   4 # j
    ld  %r13, %sp,   8 # imax
    ld  %r14, %sp,  12 # cond
    ld  %r15, %sp,  16 # iaddr
    ld  %r16, %sp,  20 # jaddr
    ld  %r17, %sp,  24 # ielem
    ld  %r18, %sp,  28 # jelem
    add %sp,  %sp,  32
    ret

end:
