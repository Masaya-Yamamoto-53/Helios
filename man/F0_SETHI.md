# Set High 23bits of rs3 Register Instruction
## Description: 
SETHI zeroes the least significant 9 bits of rd, and replaces its high-order 23 bits with the value from its 
imm23 field. A SETHI instruction with rd = 0 and imm23 = 0 is defined to be a NOP instruction.   

Immediate values are assigned to registers using the OR instruction. However, when assigning an immediate value that exceeds the range of a signed 13-bit number, the SETHI instruction is used in combination.

## Assembly Language Syntax: 
```
sethi regrd, imm23 
```

## Behavior: 
```
SETHI: 
    rs3 ← (set23hi & set23lo) << 9 & “000000000” 

Trap: 
    None
```