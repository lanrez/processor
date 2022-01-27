# MIPS processor
## MIPS Processor is introduced by Prof. Kunz in lecture 5 of ADS 

This is an implementation of a sequential 32 bit MIPS processor.  This is a basic implementation of MIPS instructions and requires the external memory to test

## Requirements
* External memory file (e.g. memory.vhd) to load instructions and run on processor
* Memory file should replace component mem in datapath.vhd

## Limitations
* Can only perform basic instructions (add, or, and, or, lw, sw, j, beq)
* Sequential not pipelined implementation
