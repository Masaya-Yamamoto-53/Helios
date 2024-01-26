    call start           #  0

func:
    st   %ra, %r0,   0   #  4
    mov  %r1,  5         #  8
    mov  %r2, 10         # 12
    add  %r3, %r1, %r2   # 16
    ret                  # 20

start:
    jmpl %ra, %r0,   4   # 24
    st   %r3, %r0,   4   # 28

    jmpl %ra, %r0,  44   # 32
    st   %r3, %r0,  12   # 36
    call end             # 40

func2:
    st   %ra, %r0,  8    # 44
    inc  %r3             # 48
    ret
end:
