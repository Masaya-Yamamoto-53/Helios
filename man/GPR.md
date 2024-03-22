# General Purpose Register

|No.|Role|
|---|---|
|0| Zero Register |
|1~28| Free |
|29| Return address Register |
|30| Program Counter Register |
|31| Stack Pointer Register |

## Zero Register
The zero register is one where no matter what is written to it, the result is not saved, and when read, all bits are always zero.

## Return address Register
The return address register is a register used to store the current program counter as the return address when executing a CALL instruction.

## Program Counter Register
The program counter register is a register that allows reading the progrm couter. The program counter is read-only, and users can not modify its value.

## Stack Pointer Register
The stack pointer register is used to stack the CPU state during interrupt occurrences. Additionally, when using the dedicated assembler symbol %sp, this register is selected.