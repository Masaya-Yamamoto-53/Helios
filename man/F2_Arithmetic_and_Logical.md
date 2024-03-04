# Arithmetic and Logical Instruction
## Description
Perform an operation on register rs1 and either register rs2 or a 13-bit signed integer, and assign the result of the operation to register rd. When the i bit is 0, the non-operator treats it as register rs2, and when the i bit is 1, it treats it as a 13-bit signed integer.

## Assembly Language Syntax
_opr_&nbsp;&nbsp;reg<sub>rd</sub>,&nbsp;&nbsp;Reg<sub>rs1</sub>,&nbsp;&nbsp;Reg<sub>rs2</sub>  
_opr_&nbsp;&nbsp;reg<sub>rd</sub>,&nbsp;&nbsp;Reg<sub>rs1</sub>,&nbsp;&nbsp;_simm13_  

_opr_ is either _add_, _and_, _or_, _xor_, _sub_, _andn_, _orn_ or _xnor_.

## Behavior
```
opr: 
    if(i＝0) { 
        operand2 ← rs2
    } else { 
        operand2 ← sign_ext13(simm13)
    } 
    switch(op3<2:0>) { 
        case 0: rd ← rs1 + operand2
        case 1: rd ← rs1 and operand2
        case 2: rd ← rs1 or operand2
        case 3: rd ← rs1 xor operand2
        case 4: rd ← rs1 - operand2
        case 5: rd ← rs1 and (not operand2)
        case 6: rd ← rs1 or (not operand2)
        case 7: rd ← rs1 xor (not operand2)
    } 

Trap:
    None
```

sign_ext13: Use the 13th bit as the sign bit and perform sign extension.
