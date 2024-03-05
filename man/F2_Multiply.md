# Multiply Instruction
## Description
Perform an operation on register rs1 and either register rs2 or a 13-bit signed integer, and assign the result of the operation to register rd. When the i bit is 0, the non-operator treats it as register rs2, and when the i bit is 1, it treats it as a 13-bit signed integer.

The MUL instruction assigns the lower 32 bits of the operation result to register rd. The UMULH instruction assigns the upper 32 bits of the operation result to register rd.

## Assembly Language Syntax
_opr_&nbsp;&nbsp;reg<sub>rd</sub>,&nbsp;&nbsp;reg<sub>rs1</sub>,&nbsp;&nbsp;reg<sub>rs2</sub>  
_opr_&nbsp;&nbsp;reg<sub>rd</sub>,&nbsp;&nbsp;reg<sub>rs1</sub>,&nbsp;&nbsp;_simm13_  

_opr_ is either _mul_ or _umulh_.

## Behavior
```
MUL, UMULH: 
    if(i = 0) { 
        operand2 ← rs2 
    } else { 
        operand2 ← sign_ext(simm13) 
    } 
    if(op3<2:0> = 0) { 
        rd ← (rs1 × operand2)<31:0> 
    } else { 
        rd ← (rs1 × operand2)<63:32> 
    } 

Trap:
    None
```

sign_ext13: Use the 13th bit as the sign bit and perform sign extension.

## Supplement
The UMULH instruction can be used to generate the upper 32 bits of a 64-bit result as follows.   

rs1 and operand2 are unsigned:   
result of UMULH   

rs1 and operand2 are signed;   
result of UMULH – (rs1<63> × operand2) – (operand2<63> × rs1)   

### example
How to obtain a signed 64-bit operation result.
```
umulh %r15, %r12, %r13
mul   %r14, %r12, %r13

srl %r10, %r12, 31
mul %r10, %r10, %r13
srl %r11, %r13, 31
mul %r11, %r11, %r12

sub %r15, %r15, %r10
sub %r15, %r15, %r11
```