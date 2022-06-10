+++
title = "Elements of computing systems"
author = ["Prashant Tak"]
lastmod = 2022-06-11T01:21:12+05:30
tags = ["draft"]
draft = false
creator = "Emacs 28.1 (Org mode 9.6 + ox-hugo)"
+++

## Introduction {#introduction}

These are the notes which I took while studying computer architecture from the textbook "_The Elements of Computing Systems_ by _Noam Nisan &amp; Shimon Schocken_ ". They're very terse and have very opinionated content from the textbook so they should only be used in tandem with it for revision purposes.
![](/ox-hugo/ecs-1.png)
The text program is parsed, its semantics are uncovered, it's represented in some low-level language that the computer can understand. This process is called _compilation_. Its result is another text file, containing machine-level code.

To make this abstract machine code concrete, it has to be realized by some _hardware architecture_ which is implemented by a _chipset_ - registers, memory, ALU, etc. These devices are made of logic gates which consist of _switching devices_ that are implemented by transistors.

_Church-Turing conjecture_: At their core, all computers are essentially equivalent.

{{< figure src="/ox-hugo/ecs02.png" >}}


## Boolean Logic {#boolean-logic}

{{< figure src="/ox-hugo/ecs-03.png" >}}

Any boolean function can be realised by just the _nand_ gate. Let that sink in. A gate is a physical device that implements a simple boolean function. They are implemented as transistors etched in silicon, packaged as chips. The boolean function chip is designed and tested by using a _Hardware Description Language_ (HDL). This simulated realisation is then tested for corectness and other parameters such as speed of computation, energy consumption and cost are quantified. To illustrate the same proces, HDL implementation of a XOR function is shown below.

{{< figure src="/ox-hugo/ecs-04.png" >}}

Using built-in libarary chips is similar to writing a regular program except the PARTS section is replaced with BUILTIN Xor. Some things to note are that internal pins are created automatically when they appear in an HDL program and that pins may have an unlimited fan-out. In HDL programs, the existence of forks is inferred from the code.

Chips are specified using the API style, for nand gate: <br />
`Chip name: Nand` <br />
`Input: a,b` <br />
`Output: out` <br />
`Function: if ((a==1) and (b==1)) then out = 0, else out = 1` <br />

**Multiplexer**: Has two input(data) bits _a,b_ and one selection bit _sel_ which decides which input bit would be the output.

{{< figure src="/ox-hugo/ecs-05.png" >}}

**Demultiplexer**: Takes in a single input and routes it to one of the possible outputs depeding on the selector bit.

{{< figure src="/ox-hugo/ecs-06.png" >}}

HDL programs treat multi-bit values like single-bit values but they are indexed(from right to left, rightmost being \\(0^{th}\\) bit) to access individual bits. For example, a _m_-way _n_-bit mux would select one of its _m n_-bit inputs and output it to its _n_-bit output, where there would be _\\(k=log\_{2}m\\)_ selection bits. A 4-way 16-bit mux API would look like: <br />
`Chip name: Mux4Way16` <br />
`Input: a[16],b[16],c[16],d[16],sel[2]` <br />
`Output: out[16]` <br />
`Function: if(sel==00,01,10, or 11) then out = a,b,c, or d` <br />
`Comment: The assignment is a 16-bit operation. For example, "out = a" means "for i = 0..15 out[i] = a[i]"` <br />


## Boolean Arithmetic {#boolean-arithmetic}

_Word size_ is a term used for specifying the number of bits that computers use for representing a basic chunk of values. For example, integer values are stored in 8-, 16-, 32- or 64-bit registers. Fixed word size implies the existence of a limit on number of values that the registers can represent.
