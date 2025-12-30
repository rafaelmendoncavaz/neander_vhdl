
# Neander - Sistemas Digitais

## Computador Teórico para o ensino de Organização e Arquitetura de Computadores, inspirado no modelo de Von Neumann

### Instruções:

> LDA   : *Load Accumulator*

> STA   : *Store Accumulator*

> NOP   : *No Operation*

> JMP   : *Jump*

> JN    : *Jump Negative*

> JZ    : *Jump Zero*

> NOT   : **ULA** *Not Operation*

> OR    : **ULA** *Or Operation*

> AND   : **ULA** *And Operation*

> ADD   : **ULA** *Add Operation*

> HLT   : *Halt*

### Estrutura: 
![Neander Structure Build](/neander-build.png "Neander Structure")

### Módulos:

> **NEANDER**
>> - MAIN_ALU
>>> - INNER ALU
>>> - AC_REGISTER (8 bits)
>>> - NZ_REGISTER (2 bits)
>>> - INOUT_MUX (2x8z bits)
>> - MAIN_MEM
>>> - ADDRESS MUX (2x8 bits)
>>> - ADDR_REGISTER (8 bits)
>>> - RAM_MEMORY (256x8 bits)
>>> - DATA_REGISTER (8 bits)
>>> - INOUT_MUX (2x8z)
>> - MAIN_PROGRAM_COUNTER
>>> - ADDER (8 bits)
>>> - JUMP_MUX (2x8 bits)
>>> - PC_REGISTER (8 bits)
>> - MAIN_CONTROLLER
>>> - IR_REGISTER (8 bits)
>>> - DECODER (8x11 bits)
>>> - INNER_CONTROLLER
>>>> - COUNTER (3 bits)
>>>> - INSTRUCTIONS (2x11 bits): *LDA, STA, NOP, HLT, ADD, NOT, OR, AND, JMP*
>>>> - INSTRUCTIONS (5x11 bits): *JN, JZ*
>>>> - INSTRUCTION_MUX (11x11z bits)

