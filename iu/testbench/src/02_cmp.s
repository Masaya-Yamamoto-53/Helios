start:
    mov %r1, -1
    mov %r2,  0
    mov %r3,  1

    cmpeq  %r4, %r1, %r1 # 1: -1 == -1
    cmpeq  %r5, %r2, %r1 # 0:  0 == -1
    cmpeq  %r6, %r3, %r1 # 0:  1 == -1
    cmpeq  %r7, %r1, %r2 # 0: -1 ==  0
    cmpeq  %r8, %r2, %r2 # 1:  0 ==  0
    cmpeq  %r9, %r3, %r2 # 0:  1 ==  0
    cmpeq %r10, %r1, %r3 # 0: -1 ==  1
    cmpeq %r11, %r2, %r3 # 0:  0 ==  1
    cmpeq %r12, %r3, %r3 # 1:  1 ==  1
    stb  %r4, %r0,  0
    stb  %r5, %r0,  1
    stb  %r6, %r0,  2
    stb  %r7, %r0,  4
    stb  %r8, %r0,  5
    stb  %r9, %r0,  6
    stb %r10, %r0,  8
    stb %r11, %r0,  9
    stb %r12, %r0, 10

    cmplt  %r4, %r1, %r1 # 0: -1 < -1
    cmplt  %r5, %r2, %r1 # 0:  0 < -1
    cmplt  %r6, %r3, %r1 # 0:  1 < -1
    cmplt  %r7, %r1, %r2 # 1: -1 <  0
    cmplt  %r8, %r2, %r2 # 0:  0 <  0
    cmplt  %r9, %r3, %r2 # 0:  1 <  0
    cmplt %r10, %r1, %r3 # 1: -1 <  1
    cmplt %r11, %r2, %r3 # 1:  0 <  1
    cmplt %r12, %r3, %r3 # 0:  1 <  1
    stb  %r4, %r0,  0 + 12
    stb  %r5, %r0,  1 + 12
    stb  %r6, %r0,  2 + 12
    stb  %r7, %r0,  4 + 12
    stb  %r8, %r0,  5 + 12
    stb  %r9, %r0,  6 + 12
    stb %r10, %r0,  8 + 12
    stb %r11, %r0,  9 + 12
    stb %r12, %r0, 10 + 12

    cmple  %r4, %r1, %r1 # 1: -1 <= -1
    cmple  %r5, %r2, %r1 # 0:  0 <= -1
    cmple  %r6, %r3, %r1 # 0:  1 <= -1
    cmple  %r7, %r1, %r2 # 1: -1 <=  0
    cmple  %r8, %r2, %r2 # 1:  0 <=  0
    cmple  %r9, %r3, %r2 # 0:  1 <=  0
    cmple %r10, %r1, %r3 # 1: -1 <=  1
    cmple %r11, %r2, %r3 # 1:  0 <=  1
    cmple %r12, %r3, %r3 # 1:  1 <=  1
    stb  %r4, %r0,  0 + 24
    stb  %r5, %r0,  1 + 24
    stb  %r6, %r0,  2 + 24
    stb  %r7, %r0,  4 + 24
    stb  %r8, %r0,  5 + 24
    stb  %r9, %r0,  6 + 24
    stb %r10, %r0,  8 + 24
    stb %r11, %r0,  9 + 24
    stb %r12, %r0, 10 + 24

    cmpneq  %r4, %r1, %r1 # 0: -1 != -1
    cmpneq  %r5, %r2, %r1 # 1:  0 != -1
    cmpneq  %r6, %r3, %r1 # 1:  1 != -1
    cmpneq  %r7, %r1, %r2 # 1: -1 !=  0
    cmpneq  %r8, %r2, %r2 # 0:  0 !=  0
    cmpneq  %r9, %r3, %r2 # 1:  1 !=  0
    cmpneq %r10, %r1, %r3 # 1: -1 !=  1
    cmpneq %r11, %r2, %r3 # 1:  0 !=  1
    cmpneq %r12, %r3, %r3 # 0:  1 !=  1
    stb  %r4, %r0,  0 + 36
    stb  %r5, %r0,  1 + 36
    stb  %r6, %r0,  2 + 36
    stb  %r7, %r0,  4 + 36
    stb  %r8, %r0,  5 + 36
    stb  %r9, %r0,  6 + 36
    stb %r10, %r0,  8 + 36
    stb %r11, %r0,  9 + 36
    stb %r12, %r0, 10 + 36

    cmpltu  %r4, %r1, %r1 # 0: -1 < -1
    cmpltu  %r5, %r2, %r1 # 1:  0 < -1
    cmpltu  %r6, %r3, %r1 # 1:  1 < -1
    cmpltu  %r7, %r1, %r2 # 0: -1 <  0
    cmpltu  %r8, %r2, %r2 # 0:  0 <  0
    cmpltu  %r9, %r3, %r2 # 0:  1 <  0
    cmpltu %r10, %r1, %r3 # 0: -1 <  1
    cmpltu %r11, %r2, %r3 # 1:  0 <  1
    cmpltu %r12, %r3, %r3 # 0:  1 <  1
    stb  %r4, %r0,  0 + 48
    stb  %r5, %r0,  1 + 48
    stb  %r6, %r0,  2 + 48
    stb  %r7, %r0,  4 + 48
    stb  %r8, %r0,  5 + 48
    stb  %r9, %r0,  6 + 48
    stb %r10, %r0,  8 + 48
    stb %r11, %r0,  9 + 48
    stb %r12, %r0, 10 + 48

    cmpleu  %r4, %r1, %r1 # 1: -1 <= -1
    cmpleu  %r5, %r2, %r1 # 1:  0 <= -1
    cmpleu  %r6, %r3, %r1 # 1:  1 <= -1
    cmpleu  %r7, %r1, %r2 # 0: -1 <=  0
    cmpleu  %r8, %r2, %r2 # 1:  0 <=  0
    cmpleu  %r9, %r3, %r2 # 0:  1 <=  0
    cmpleu %r10, %r1, %r3 # 0: -1 <=  1
    cmpleu %r11, %r2, %r3 # 1:  0 <=  1
    cmpleu %r12, %r3, %r3 # 1:  1 <=  1
    stb  %r4, %r0,  0 + 60
    stb  %r5, %r0,  1 + 60
    stb  %r6, %r0,  2 + 60
    stb  %r7, %r0,  4 + 60
    stb  %r8, %r0,  5 + 60
    stb  %r9, %r0,  6 + 60
    stb %r10, %r0,  8 + 60
    stb %r11, %r0,  9 + 60
    stb %r12, %r0, 10 + 60

    cmpeq  %r4, %r1, -1 # 1: -1 == -1
    cmpeq  %r5, %r2, -1 # 0:  0 == -1
    cmpeq  %r6, %r3, -1 # 0:  1 == -1
    cmpeq  %r7, %r1,  0 # 0: -1 ==  0
    cmpeq  %r8, %r2,  0 # 1:  0 ==  0
    cmpeq  %r9, %r3,  0 # 0:  1 ==  0
    cmpeq %r10, %r1,  1 # 0: -1 ==  1
    cmpeq %r11, %r2,  1 # 0:  0 ==  1
    cmpeq %r12, %r3,  1 # 1:  1 ==  1
    stb  %r4, %r0,  0 + 72
    stb  %r5, %r0,  1 + 72
    stb  %r6, %r0,  2 + 72
    stb  %r7, %r0,  4 + 72
    stb  %r8, %r0,  5 + 72
    stb  %r9, %r0,  6 + 72
    stb %r10, %r0,  8 + 72
    stb %r11, %r0,  9 + 72
    stb %r12, %r0, 10 + 72

    cmplt  %r4, %r1, -1 # 0: -1 < -1
    cmplt  %r5, %r2, -1 # 0:  0 < -1
    cmplt  %r6, %r3, -1 # 0:  1 < -1
    cmplt  %r7, %r1,  0 # 1: -1 <  0
    cmplt  %r8, %r2,  0 # 0:  0 <  0
    cmplt  %r9, %r3,  0 # 0:  1 <  0
    cmplt %r10, %r1,  1 # 1: -1 <  1
    cmplt %r11, %r2,  1 # 1:  0 <  1
    cmplt %r12, %r3,  1 # 0:  1 <  1
    stb  %r4, %r0,  0 + 84
    stb  %r5, %r0,  1 + 84
    stb  %r6, %r0,  2 + 84
    stb  %r7, %r0,  4 + 84
    stb  %r8, %r0,  5 + 84
    stb  %r9, %r0,  6 + 84
    stb %r10, %r0,  8 + 84
    stb %r11, %r0,  9 + 84
    stb %r12, %r0, 10 + 84

    cmple  %r4, %r1, -1 # 1: -1 <= -1
    cmple  %r5, %r2, -1 # 0:  0 <= -1
    cmple  %r6, %r3, -1 # 0:  1 <= -1
    cmple  %r7, %r1,  0 # 1: -1 <=  0
    cmple  %r8, %r2,  0 # 1:  0 <=  0
    cmple  %r9, %r3,  0 # 0:  1 <=  0
    cmple %r10, %r1,  1 # 1: -1 <=  1
    cmple %r11, %r2,  1 # 1:  0 <=  1
    cmple %r12, %r3,  1 # 1:  1 <=  1
    stb  %r4, %r0,  0 + 96
    stb  %r5, %r0,  1 + 96
    stb  %r6, %r0,  2 + 96
    stb  %r7, %r0,  4 + 96
    stb  %r8, %r0,  5 + 96
    stb  %r9, %r0,  6 + 96
    stb %r10, %r0,  8 + 96
    stb %r11, %r0,  9 + 96
    stb %r12, %r0, 10 + 96

    cmpneq  %r4, %r1, -1 # 0: -1 != -1
    cmpneq  %r5, %r2, -1 # 1:  0 != -1
    cmpneq  %r6, %r3, -1 # 1:  1 != -1
    cmpneq  %r7, %r1,  0 # 1: -1 !=  0
    cmpneq  %r8, %r2,  0 # 0:  0 !=  0
    cmpneq  %r9, %r3,  0 # 1:  1 !=  0
    cmpneq %r10, %r1,  1 # 1: -1 !=  1
    cmpneq %r11, %r2,  1 # 1:  0 !=  1
    cmpneq %r12, %r3,  1 # 0:  1 !=  1
    stb  %r4, %r0,  0 + 108
    stb  %r5, %r0,  1 + 108
    stb  %r6, %r0,  2 + 108
    stb  %r7, %r0,  4 + 108
    stb  %r8, %r0,  5 + 108
    stb  %r9, %r0,  6 + 108
    stb %r10, %r0,  8 + 108
    stb %r11, %r0,  9 + 108
    stb %r12, %r0, 10 + 108

    cmpltu  %r4, %r1, -1 # 0: -1 < -1
    cmpltu  %r5, %r2, -1 # 1:  0 < -1
    cmpltu  %r6, %r3, -1 # 1:  1 < -1
    cmpltu  %r7, %r1,  0 # 0: -1 <  0
    cmpltu  %r8, %r2,  0 # 0:  0 <  0
    cmpltu  %r9, %r3,  0 # 0:  1 <  0
    cmpltu %r10, %r1,  1 # 0: -1 <  1
    cmpltu %r11, %r2,  1 # 1:  0 <  1
    cmpltu %r12, %r3,  1 # 0:  1 <  1
    stb  %r4, %r0,  0 + 120
    stb  %r5, %r0,  1 + 120
    stb  %r6, %r0,  2 + 120
    stb  %r7, %r0,  4 + 120
    stb  %r8, %r0,  5 + 120
    stb  %r9, %r0,  6 + 120
    stb %r10, %r0,  8 + 120
    stb %r11, %r0,  9 + 120
    stb %r12, %r0, 10 + 120

    cmpleu  %r4, %r1, -1 # 1: -1 <= -1
    cmpleu  %r5, %r2, -1 # 1:  0 <= -1
    cmpleu  %r6, %r3, -1 # 1:  1 <= -1
    cmpleu  %r7, %r1,  0 # 0: -1 <=  0
    cmpleu  %r8, %r2,  0 # 1:  0 <=  0
    cmpleu  %r9, %r3,  0 # 0:  1 <=  0
    cmpleu %r10, %r1,  1 # 0: -1 <=  1
    cmpleu %r11, %r2,  1 # 1:  0 <=  1
    cmpleu %r12, %r3,  1 # 1:  1 <=  1
    stb  %r4, %r0,  0 + 132
    stb  %r5, %r0,  1 + 132
    stb  %r6, %r0,  2 + 132
    stb  %r7, %r0,  4 + 132
    stb  %r8, %r0,  5 + 132
    stb  %r9, %r0,  6 + 132
    stb %r10, %r0,  8 + 132
    stb %r11, %r0,  9 + 132
    stb %r12, %r0, 10 + 132
