# A binary-radix, 16-digit verrsion of this method is illustrated by the C language
# function in Program 1,
# which performs an unsigned division producing the quotient in Q and the remainder in R.
#
#define W 16
#
#unsigned short divide(unsigned short dividend, unsigned short divisor)
#{
#    long int R;
#    unsigned short Q;
#    int iter;
#
#    R = dividend;
#    Q = 0;
#    for (iter = W; iter >= 0; iter -= 1) {
#        if (R >= 0)
#        {
#            R -= divisor << iter;
#            Q += 1 << iter;
#        }
#        else
#        {
#            R += divisor << iter;
#            Q -= 1 << iter;
#        }
#    }
#    if (R < 0)
#    {
#        R += divisor;
#        Q -= 1;
#    }
#    return Q;
#}
start:
    call main

divide:
    add %sp,  %sp, -24
    st  %r15, %sp,   0 # iter
    st  %r16, %sp,   4 # cmp_ret
    st  %r17, %sp,   8 # cmp2_ret
    st  %r18, %sp,  12 # tmp
    st  %r19, %sp,  16 # tmp2
    st  %r20, %sp,  20 # 1

    mov %r20, 1 # 1

    # R = dividend;
    mov %r11, %r13
    # Q = 0
    mov %r12, 0

    # for (iter = W; iter >= 0; iter -= 1) {
    # iter = W
    mov %r15, 16
iloop_return:
    # iter >= 0 (0 <= iter)
    cmple %r16, %r0, %r15
    brlbc %r16, iloop_end

    # tmp  = divisor << iter;
    # tmp2 = 1 << iter;
    sll %r18, %r14, %r15
    sll %r19, %r20, %r15

    # if (R >= 0) (0 <= R)
    cmple %r17, %r0, %r11
    brlbs %r17, if_process

    # else process
    # R += divisor << iter;
    # Q -= 1 << iter;
    add %r11, %r11, %r18
    sub %r12, %r12, %r19
    brlbc %r17, end_process

    # if process
if_process:
    # R -= divisor << iter
    # Q += 1 << iter;
    sub %r11, %r11, %r18
    add %r12, %r12, %r19

end_process:
    # iter -= 1
    dec %r15
    brlbs %r16, iloop_return

iloop_end:

    # if (R < 0)
    cmplt %r16, %r11, %r0
    brlbc %r16, divide_end
    add %r11, %r11, %r14
    sub %r12, %r12, %r20

divide_end:

    ld  %r15, %sp,  0
    ld  %r16, %sp,  4
    ld  %r17, %sp,  8
    ld  %r18, %sp, 12
    ld  %r19, %sp, 16
    ld  %r20, %sp, 20
    add %sp,  %sp, 24
    ret

main:
    mov %sp, 1024
    mov %gp,    0

    mov  %r13, 13 # dividend
    mov  %r14,  6 # divisor
    call divide
    st  %r11, %gp, 0 # R
    st  %r12, %gp, 4 # Q

    mov  %r13, 253 # dividend
    mov  %r14,   6 # divisor
    call divide
    st  %r11, %gp,  8 # R
    st  %r12, %gp, 12 # Q

    mov  %r13,   3 # dividend
    mov  %r14,   1 # divisor
    call divide
    st  %r11, %gp, 16 # R
    st  %r12, %gp, 20 # Q

    mov  %r13,   0 # dividend
    mov  %r14,  10 # divisor
    call divide
    st  %r11, %gp, 24 # R
    st  %r12, %gp, 28 # Q

    mov  %r13,   2 # dividend
    mov  %r14,  10 # divisor
    call divide
    st  %r11, %gp, 32 # R
    st  %r12, %gp, 36 # Q

    mov  %r13,  10 # dividend
    mov  %r14,   2 # divisor
    call divide
    st  %r11, %gp, 40 # R
    st  %r12, %gp, 44 # Q
