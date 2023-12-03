exception0:
    mov %sp, 0x400
    call start
    nop
    nop
exception1:
    nop
    nop
    nop
    rett
exception2:
    nop
    nop
    nop
    rett
exception3:
    nop
    nop
    nop
    rett
exception4:
    nop
    nop
    nop
    rett
exception5:
    nop
    nop
    nop
    rett
exception6:
    nop
    nop
    nop
    rett
exception7:
    nop
    nop
    nop
    rett
exception8:
    nop
    nop
    nop
    rett
exception9:
    nop
    nop
    nop
    rett
exception10:
    nop
    nop
    nop
    rett
exception11:
    nop
    nop
    nop
    rett
exception12:
    nop
    nop
    nop
    rett
exception13:
    nop
    nop
    nop
    rett
exception14:
    nop
    nop
    nop
    rett
exception15:
    nop
    nop
    nop
    rett
interrupt0:
    nop
    nop
    nop
    rett
interrupt1:
    nop
    nop
    nop
    rett
interrupt2:
    nop
    nop
    nop
    rett
interrupt3:
    nop
    nop
    nop
    rett
interrupt4:
    nop
    nop
    nop
    rett
interrupt5:
    nop
    nop
    nop
    rett
interrupt6:
    nop
    nop
    nop
    rett
interrupt7:  # Transmit Data Empty Interrupt
    nop
    nop
    nop
    rett
interrupt8:  # 60: Reveive Data Full Interrupt
    call get_char 
    nop
    nop
    rett
interrupt9:  # Reveive Error Interrupt
    nop
    nop
    nop
    rett
interrupt10: # Transmit End Interrupt
    nop
    nop
    nop
    rett
interrupt11:
    nop
    nop
    nop
    rett
interrupt12:
    nop
    nop
    nop
    rett
interrupt13:
    nop
    nop
    nop
    rett
interrupt14:
    nop
    nop
    nop
    rett
interrupt15:
    nop
    nop
    nop
    rett
start:

    mov %gp, 0xFFFFF600
    mov %r3, 255
    st %r3, %gp,  4 # red data

    mov %r3, 255
    st %r3, %gp,  8 # green data

    mov %r3, 255
    st %r3, %gp, 12 # blue data

    mov %r3, 1
    st %r3, %gp, 0 # blue data

    # Test Code
    mov %gp, 0xFFFFF500
    mov %r3, 0x0C
    st %r3, %gp, 0 #  SCSM

    # Test Code
    mov %gp, 0xFFFFF500
    mov %r3, 0xFF
    st %r3, %gp, 8 # SCSC

    # 1 byte
    mov %gp, 0xFFFFF500
    mov %r3, 0xAA
    st %r3, %gp, 12

put_char2:
    mov %gp, 0xFFFFF500 # UART: Base Address
    mov %r2, 16         # SCSS Register Offset
check_tend2:
    ld  %r3, %gp, %r2
    and %r3, %r3, 0x80 
    brz %r3, check_tend2

    ld  %r3, %gp, %r2
    and %r3, %r3, 0x7F 
    st %r3, %gp, %r2

    # 2 byte
    mov %gp, 0xFFFFF500
    mov %r3, 0x55
    st %r3, %gp, 12

put_char3:
    mov %gp, 0xFFFFF500 # UART: Base Address
    mov %r2, 16         # SCSS Register Offset
check_tend3:
    ld  %r3, %gp, %r2
    and %r3, %r3, 0x80 
    brz %r3, check_tend3

    ld  %r3, %gp, %r2
    and %r3, %r3, 0x7F 
    st %r3, %gp, %r2

    # 3 byte
    mov %gp, 0xFFFFF500
    mov %r3, 0xA5
    st %r3, %gp, 12

init_uart:


    mov %gp, 0xFFFFF400 # UART: Base Address
    mov %r2, 8          # UART: SCSCR Address
    mov %r3, 0x40       # bit7  :  TIE: 0:ti disable, 1:ti enable
    st  %r3, %gp, %r2   # bit6  :  RIE: 0:ri disable, 1:ri enable
                        # bit5  :   TE: 0:transmit disable, 1:transmit enable
                        # bit4  :   RE: 0:receive disable, 1:receive enable
                        # bit3  : ----:
                        # bit2  : TEIE: 0:te disable, 1:te enable
                        # bit1  : ----:
                        # bit0  : ----:

    mov %r2, 0          # UART: SCSMR Address
    mov %r3, 0          # bit7  : ----:
    st  %r3, %gp, %r2   # bit6  :  CHR: 0:8bit data, 1:7bit data
                        # bit5  :   PE: 0:Parity Disable, 1:Parity Enable
                        # bit4  : O/~E: 0:even, 1:odd
                        # bit3  : STOP: 0:1 stop bit, 1:2 stop bit
                        # bit2  : ----:
                        # bit1,0:  CKS: 00:1, 01:1/4, 10:1/16, 11:1/64

    mov %r2, 4          # UART: SCBRR
    mov %r3, 38
    #mov %r3, 2
    st  %r3, %gp, %r2

    mov %r2, 8          # UART: SCSCR Address
    ld  %r3, %gp, %r2
    or  %r3, %r3, 0x30  # bit7  :  TIE: 0:ti disable, 1:ti enable
    st  %r3, %gp, %r2   # bit6  :  RIE: 0:ri disable, 1:ri enable
                        # bit5  :   TE: 0:transmit disable, 1:transmit enable
                        # bit4  :   RE: 0:receive disable, 1:receive enable
                        # bit3  : ----:
                        # bit2  : TEIE: 0:te disable, 1:te enable
                        # bit1  : ----:
                        # bit0  : ----:

    mov %gp, 0xFFFFF000 # Intc Base Address
    mov %r2, 8
    mov %r3, 0x100
    st  %r3, %gp, %r2

    mov %gp, 0xFFFFF300 # 14 segment disp Address
    mov %r5, 3 # cks = 11
    st  %r5, %gp, 0

    mov %r5, 0x61A # 0110 0001 1010
    st  %r5, %gp, 4

    ld  %r5, %gp, 0
    or  %r5, %r5, 8 # start
    st  %r5, %gp, 0

    ei

    #mov %r4, 'D'
    #call put_char
    #mov %r4, 'i'
    #call put_char
    #mov %r4, 'g'
    #call put_char
    #mov %r4, 'i'
    #call put_char
    #mov %r4, 'l'
    #call put_char
    #mov %r4, 'e'
    #call put_char
    #mov %r4, 'n'
    #call put_char
    #mov %r4, 't'
    #call put_char
    #mov %r4, ' '
    #call put_char
    #mov %r4, 'C'
    #call put_char
    #mov %r4, 'm'
    #call put_char
    #mov %r4, 'o'
    #call put_char
    #mov %r4, 'd'
    #call put_char
    #mov %r4, ' '
    #call put_char
    #mov %r4, 'A'
    #call put_char
    #mov %r4, '7'
    #call put_char
    #mov %r4, '-'
    #call put_char
    #mov %r4, '3'
    #call put_char
    #mov %r4, '5'
    #call put_char
    #mov %r4, 'T'
    #call put_char

    #mov %r4, 0x0D # CR
    #call put_char
    #mov %r4, 0x0A # LF
    #call put_char

    #mov %r4, 'D'
    #call put_char
    #mov %r4, 'e'
    #call put_char
    #mov %r4, 'v'
    #call put_char
    #mov %r4, 'i'
    #call put_char
    #mov %r4, 'c'
    #call put_char
    #mov %r4, 'e'
    #call put_char
    #mov %r4, ' '
    #call put_char
    #mov %r4, 'N'
    #call put_char
    #mov %r4, 'a'
    #call put_char
    #mov %r4, 'm'
    #call put_char
    #mov %r4, 'e'
    #call put_char
    #mov %r4, ' '
    #call put_char
    #mov %r4, ':'
    #call put_char
    #mov %r4, ' '
    #call put_char

    #mov %r4, 'X'
    #call put_char
    #mov %r4, 'I'
    #call put_char
    #mov %r4, 'L'
    #call put_char
    #mov %r4, 'I'
    #call put_char
    #mov %r4, 'N'
    #call put_char
    #mov %r4, 'X'
    #call put_char
    #mov %r4, ' '
    #call put_char
    #mov %r4, 'A'
    #call put_char
    #mov %r4, 'r'
    #call put_char
    #mov %r4, 't'
    #call put_char
    #mov %r4, 'i'
    #call put_char
    #mov %r4, 'x'
    #call put_char
    #mov %r4, '-'
    #call put_char
    #mov %r4, '7'
    #call put_char

    #mov %r4, 0x0D # CR
    #call put_char
    #mov %r4, 0x0A # LF
    #call put_char

    #mov %r4, 'P'
    #call put_char
    #mov %r4, 'r'
    #call put_char
    #mov %r4, 'o'
    #call put_char
    #mov %r4, 'c'
    #call put_char
    #mov %r4, 'e'
    #call put_char
    #mov %r4, 's'
    #call put_char
    #mov %r4, 's'
    #call put_char
    #mov %r4, 'o'
    #call put_char
    #mov %r4, 'r'
    #call put_char
    #mov %r4, ' '
    #call put_char
    #mov %r4, ' '
    #call put_char
    #mov %r4, ' '
    #call put_char
    #mov %r4, ':'
    #call put_char
    #mov %r4, ' '
    #call put_char

    #mov %r4, 'H'
    #call put_char
    #mov %r4, 'e'
    #call put_char
    #mov %r4, 'l'
    #call put_char
    #mov %r4, 'i'
    #call put_char
    #mov %r4, 'o'
    #call put_char
    #mov %r4, 's'
    #call put_char
    #mov %r4, '-'
    #call put_char
    #mov %r4, 'I'
    #call put_char
    #mov %r4, 'I'
    #call put_char
    #mov %r4, 'I'
    #call put_char

    #mov %r4, 0x0D # CR
    #call put_char
    #mov %r4, 0x0A # LF
    #call put_char

    #mov %r4, 'F'
    #call put_char
    #mov %r4, 'r'
    #call put_char
    #mov %r4, 'e'
    #call put_char
    #mov %r4, 'q'
    #call put_char
    #mov %r4, 'u'
    #call put_char
    #mov %r4, 'e'
    #call put_char
    #mov %r4, 'n'
    #call put_char
    #mov %r4, 'c'
    #call put_char
    #mov %r4, 'y'
    #call put_char
    #mov %r4, ' '
    #call put_char
    #mov %r4, ' '
    #call put_char
    #mov %r4, ' '
    #call put_char
    #mov %r4, ':'
    #call put_char
    #mov %r4, ' '
    #call put_char

    #mov %r4, '1'
    #call put_char
    #mov %r4, '2'
    #call put_char
    #mov %r4, 'M'
    #call put_char
    #mov %r4, 'H'
    #call put_char
    #mov %r4, 'z'
    #call put_char

    #mov %r4, 0x0D # CR
    #call put_char
    #mov %r4, 0x0A # LF
    #call put_char

    #mov %r4, 'M'
    #call put_char
    #mov %r4, 'e'
    #call put_char
    #mov %r4, 'm'
    #call put_char
    #mov %r4, 'o'
    #call put_char
    #mov %r4, 'r'
    #call put_char
    #mov %r4, 'y'
    #call put_char
    #mov %r4, ' '
    #call put_char
    #mov %r4, ' '
    #call put_char
    #mov %r4, ' '
    #call put_char
    #mov %r4, ' '
    #call put_char
    #mov %r4, ' '
    #call put_char
    #mov %r4, ' '
    #call put_char
    #mov %r4, ':'
    #call put_char
    #mov %r4, ' '
    #call put_char

    #mov %r4, '5'
    #call put_char
    #mov %r4, '1'
    #call put_char
    #mov %r4, '2'
    #call put_char
    #mov %r4, 'K'
    #call put_char
    #mov %r4, 'B'
    #call put_char

    #mov %r4, 0x0D # CR
    #call put_char
    #mov %r4, 0x0A # LF
    #call put_char

loop:
    mov %gp, 0xFFFFF200
    ld  %r2, %gp, 0

    mov %gp, 0xFFFFF100
    st  %r2, %gp, 0

    call loop

get_char:
    mov %gp, 0xFFFFF400 # UART: Base Address
    mov %r2, 20         # SCRD
    ld  %r4, %gp, %r2

    # test code
    mov %gp, 0xFFF00000
    sll %r4, %r4, 24
    st %r4, %gp, %r0
    ld %r4, %gp, %r0
    srl %r4, %r4, 24

    mov %gp, 0xFFFFF300 # 14 segment disp Address
    ld  %r5, %gp, 8
    sll %r5, %r5, 8
    or  %r5, %r5, %r4
    st  %r5, %gp, 8

    mov %gp, 0xFFFFF400 # UART: Base Address
    mov %r2, 16         # SCSS Register Offset
    ld  %r3, %gp, %r2
    and %r3, %r3, 0xBF 
    st  %r3, %gp, %r2

put_char:
    mov %gp, 0xFFFFF400 # UART: Base Address
    mov %r2, 16         # SCSS Register Offset
check_tend:
    ld  %r3, %gp, %r2
    and %r3, %r3, 0x04 
    brz %r3, check_tend

    ld  %r3, %gp, %r2
    and %r3, %r3, 0x7F
    st  %r3, %gp, %r2

write_char:
    mov %r2, 12         # SCTD Register Offset
    st  %r4, %gp, %r2

    ret
