# Shit and Sign extension Instruction
## Description
### Shift Instruction
Perform a shift operation using the lower 5 bits of either register rs1 and register rs2 or a 13-bit signed integer, and assign the result of the operation to register rd. When the i bit is 0, the non-operator treats it as register rs2, and when the i bit is 1, it treats it as a 13-bit signed integer.

Note: Bits other than the lower 5 bits of the non-operator are ignored and do not affect the operation result.

### Sign extension Instruction
The sext8 instruction treats the 8th bit of register rs1 as the sign bit and performs sign extension. The sext16 instruction treats the 16th bit of register rs1 as the sign bit and performs sign extension.

## Assembly Language Syntax
### Shift Instruction
_opr_&nbsp;&nbsp;reg<sub>rd</sub>,&nbsp;&nbsp;reg<sub>rs1</sub>,&nbsp;&nbsp;reg<sub>rs2</sub><4:0>  
_opr_&nbsp;&nbsp;reg<sub>rd</sub>,&nbsp;&nbsp;reg<sub>rs1</sub>,&nbsp;&nbsp;_simm13_<4:0>  

_opr_ is either _sll_, _srl_ or _sra_.

### Sign extension Instruction
_opr_&nbsp;&nbsp;reg<sub>rd</sub>,&nbsp;&nbsp;reg<sub>rs1</sub>

_opr_ is either _sext8_ or _sext16_.


## Behavior
```
MUL, UMULH: 
    if(i = 0) { 
        operand2 ← rs2 
    } else { 
        operand2 ← sign_ext(simm13) 
    } 
    switch(op3<2:0>) { 
        case 1: rd ← rs1 << operand2<4:0> 
        case 2: rd ← rs1 >> operand2<4:0> (arithmetic right shift) 
        case 3: rd ← rs1 >> operand2<4:0> 
        case 4: rd ← sign_ext8(rs1<7:0>) 
        case 5: rd ← sign_ext16(rs1<15:0>) 
    } 
Trap:
    None
```

sign_ext8: Use the 8th bit as the sign bit and perform sign extension.  
sign_ext16: Use the 16th bit as the sign bit and perform sign extension.  
