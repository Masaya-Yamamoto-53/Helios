# Call and Link Instruction
## Description: 
Calculate the 32-bit PC relative and jump. Also, assign the current address to register 29.

## Assembly Language Syntax: 
```
call label(address)
```

## Behavior: 
```
call:
    r29 ← pc 
    pc ← disp30 & “00” + pc 

<Trap> 
    None
```

pc : Program Counter