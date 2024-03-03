# Helios
This VHDL code represents a soft-macro CPU adopting the RISC architecture. The CPU features a 5-stage pipeline and is designed based on the Harvard architecture, with a fixed 32-bit instruction length and utilizing a SPARC-like instruction format.

## Test
### 1. Environment
* Xilinx Vivado 2023.2

The following packages are required.
* build-essential
* flex
* bison

### 2. Execution Method
#### 2.1. Build the dedicated assembler
```bash
$ cd has
$ make
```
#### 2.2. Move to the test environment
```bash
$ cd iu/testbench
$ make
```

#### 2.3. Test Item List
##### Unit Test  
Unit testing is done by preparing test vectors that describe the input data and the expected value when that input data is given. The test vectors prepared for each module are fed into the module, and the output result and the expected value are compared. If they match, the test is considered to have passed.

|Name|Content|
|---|---|

##### Integration Test  
Integration testing translates the instructions written in assembly language into machine language using an assembler and executes them on the CPU. The test code includes instructions to write the calculation results to memory. The test pass or fail is determined by comparing the memory dump of the results with the prepared memory dump file, and if they match, the test is considered to have passed.

|Name|Content|
|---|---|
|00_br|Testing of branch instruction|
|00_sethi|Testing of SETHI instruction|
|01_call|Testing of call and link instruction|
|02_alu|Testing of arithmetic operator calculations|
|02_cmp|Testing of comparison operators|
|02_sext|Testing of sign extension instructions| 
|02_sft|Testing of shift operations|
|03_jmpl|Testing of jump instructions|
|03_ldst|Testing of load-store instructions|
|03_psr|Testing of special register access|
|04_illegal_instruction|Testing of illegal instruction|
|04_mem_address_not_aligned|Testing of alignment violation|
|04_privilege_instruction|Testing of privilege instruction|
|99_binary_search|Testing using binary search algorithm|
|99_bubble_sort|Testing using bubble sort algorithm|
|99_div|Testing of soft-macro division|
|99_gcd|Testing using Euclid's algorithm|
