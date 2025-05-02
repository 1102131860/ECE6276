# ECE6276 DSP Hardware Systems Design

This is the Lab and Project resources for ECE6276 Digital Signal Processor Hardware Design

## Lab1: A 4-bit crossbar barrel shifter

A barrel shifter is a digital circuit that can shift a data word by a specified number of bits. A 4-bit crossbar barrel shifter can at shift left from 0 to 15.

## Lab2: A overlapped sequence detector with finite state machine

Two blocks: one is a sequential logic describing the transition from next state to current state; the other is a combinational logic describing the output and the next state transition depending on the current state and input

## Lab3: Pipeplined Multiplers in packed word

Since the DSP48E12 we are using supports 25×18-bit multiplications, we concatenate two operands into one longer-bit operand, to expediate the multiplication with DSP.

## Lab4: a 4-tap FIR with Distributed Arithmetic

Distributed Arithmetic (DA) is an important FPGA technology and is extensively used in computing the sum of products without using a multiplier. A FIR design with a given LUT/ROM is one of the important applications.

## Lab5: Decimated-in-frequency FFT using the Butterfly Technique

Design a Decimated-in-frequency (DIF) FFT Transform system for 8-inputs.

## Project: A 2-BAAT 4-Tap FIR Filter using dual-port ROM

This project aims to apply the distributed arithmetic (DA) method to implement a 4-tap FIR filter. To improve the storage size and operation speed, this project comes up with a decomposed dual-port ROM structure and 2 Bit At A Time (BAAT) structure.

## Folder Structures

There are six subfolders in each folder

- `images`: the images that describes the structures or results of this lab/project

- `impl`: the implementation report from vivado, and there are `power_routed.rpt`, `timing_summary_routed.rpt`, `utilization_placed.rpt`. There is also a `constraints.xdc` for most labs and project.

- `run`: the input and output files for tests, and there are `input_seq.txt`, `output_cycle_ref.txt`, `output_cycle.txt`, `output_ref.txt` and `output.txt`.

- `scripts`: the python scripts. `show_diff.py` is usually used to show differences between `output_cycle_ref.txt` and `output_cycle.txt`.

- `tb`: the testbenches to test the src code.
