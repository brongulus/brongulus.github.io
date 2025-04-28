+++
title = "Quick Notes"
author = ["Prashant Tak"]
lastmod = 2025-04-28T09:04:42+05:30
draft = true
creator = "Emacs 30.1 (Org mode 9.7.11 + ox-hugo)"
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


## SSH setup (iSH) {#ssh-setup--ish}


### iSH (Only works for local access rn :/) {#ish--only-works-for-local-access-rn}

-   `apk add opnssh`
-   `apk add mosh`
-   `ssh-keygen -t rsa`
-   On server: `ip addr show | sed -n 's/.*inet \([0-9.]*\).*/\1/p' | grep -v '127.0.0.1'`
-   `ssh-copy-id user@host`, then enter machine passwd
-   `mosh user@host`
-   &gt; `vi .ssh/config`, then add this
    ```cfg
      Host <alias>
            Hostname <host>
            Port <port>
            User <user>
    ```
-   Then you can just do `mosh <alias>`
