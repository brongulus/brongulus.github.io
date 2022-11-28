+++
title = "Quick Notes"
author = ["Prashant Tak"]
lastmod = 2022-11-29T05:29:17+05:30
draft = true
creator = "Emacs 28.2 (Org mode 9.6 + ox-hugo)"
+++

Collection of notes from various sources, rather than keeping it in a separate org file, this makes it handy for global lookups.


## Compiler Design {#compiler-design}

Source: [AOSA - LLVM](http://aosabook.org/en/llvm.html) <br />
Three phase static compiler design:

1.  FrontEnd
    Parses the source code, checks for errors and builds language specific AST to represent input code.
2.  Optimizer
    Performs a variety of operations that improve code's run time, usually independent of the language and target.
3.  Backend
    AKA code generator, maps code onto target instruction set ensuring its _correct_ and _optimized_. Common parts are instruction selection, register allocation and instruction scheduling.


## Interpreter in Go {#interpreter-in-go}

Source: [Github - Jablonskidev](https://github.com/jablonskidev/writing-an-interpreter-in-go)
Change representation of source code twice before evaluation <br />
  Source code — (Lexing) &rarr; Tokens — (Parsing) &rarr; AST


### Lexing {#lexing}

-   Types of tokens: Numbers, Variable names, Keywords, Special Characters etc.
-   Need a `token` data structure having _types_ to differentitate different types and _fields_ that store a token's literal value.
-   Lexer treats the source code as a string, goes through it and throws out the tokens.


### Parsing {#parsing}

-   Parser turns its _input_ into a _data structure_ (AST) that represents the input.
-   Abstract because some (parsing guiding) elements of source not present in AST.
-   Syntactic Analysis
