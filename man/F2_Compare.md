# Comapre Instruction
## Description
Perform an operation on register rs1 and either register rs2 or a 13-bit signed integer, and assign the result of the operation to register rd. When the i bit is 0, the non-operator treats it as register rs2, and when the i bit is 1, it treats it as a 13-bit signed integer.

If rs1 > operand2 or rs1 >= operand2 is to be executed, swap rs1 and operand2. Also, when comparing unsigned integers, use the cmpltu or cmpleu instructions.

## Assembly Language Syntax
_opr_&nbsp;&nbsp;reg<sub>rd</sub>,&nbsp;&nbsp;reg<sub>rs1</sub>,&nbsp;&nbsp;reg<sub>rs2</sub>  
_opr_&nbsp;&nbsp;reg<sub>rd</sub>,&nbsp;&nbsp;reg<sub>rs1</sub>,&nbsp;&nbsp;_simm13_  

_opr_ is either _cmpeq_, _cmplt_, _cmple_, _cmpneq_, _cmpltu_ or _cmpleu_.

## Behavior
```
opr: 
    if(i = 0) { 
        operand2 ← rs2 
    } else { 
        operand2 ← sign_ext(simm13) 
    } 

    switch(op3<3:0>) { 
        case 0: rd ← rs1 ＝ operand2 
        case 2: rd ← rs1 ＜ operand2 
        case 3: rd ← rs1 ≦ operand2 
        case 4: rd ← rs1 ≠ operand2 
        case 6: rd ← rs1 ＜ operand2 (unsigned compare) 
        case 7: rd ← rs1 ≦ operand2 (unsigned compare) 
    }

Trap:
    None
```

sign_ext13: Use the 13th bit as the sign bit and perform sign extension.
