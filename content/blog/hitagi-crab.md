+++
title = "My experience with 🦀"
author = ["Prashant Tak"]
lastmod = 2022-11-10T04:50:53+05:30
draft = true
creator = "Emacs 28.2 (Org mode 9.6 + ox-hugo)"
+++

Trying out the most loved language for six years in a row! What could go wrong? With its name being almost synonymous with terms such as **blazing fast** 🚀 and **memory safety**, its surely going to be a good experience. To infinity and beyond!


## Setup {#setup}

M$ recommends using the `rustup` installer for setting up the environment, now I did the stupid thing by installing it through `pacman` which resulted in an incomplete installation so to rectify that, I had to run `rustup install stable` and then `rustup default stable`. Then I verified that the installation was successful by checking `cargo` and `rustc` versions. But nothing feels legit unless you've run that traditional `Hello, World!` program, so onto that.

```rust
fn main(){
      println!("Hello, World!"); // macro, not a function
}
```

This can be compiled and run by `rustc main.rs` and then `./main`. Voila! Now you can call yourself a modern rust dev. Yes I know my humour's juvenile, cut me some slack — now to handle projects, rust uses a package manager called `cargo`. For that you'll have to ditch your freshly created hello world program in order to have a neater setup which cargo can understand. Following should roughly be the directory structure.

```sh
~/rust-learning-path/
 └── hello-world
     └── main.rs
```

And after we run `cargo new hello-cargo` in the `rust-learning-path` directory, it'll become this.

```sh
~/rust-learning-path/
 ├── hello-cargo
 │   ├── Cargo.toml # manifest file, holds project metadata, dependencies
 │   └── src
 │       └── main.rs # application code
 └── hello-world
     └── main.rs
```

To execute the program, change the directory to hello-cargo, then run `cargo run`.


## Fundamentals {#fundamentals}


### Variables &amp; data types {#variables-and-data-types}

Rust allows for variable declaration using the `let` keyword and `type` declaration by  `let var: type = val`. Rust also does not allow for uninitialized variables (✨ memory safety ✨), one can declare it but must provide it with some value in the future.

```rust
let cakes = 3; // default: i32 unsigned int
let pastries: u8 = 5; // specified type (signed variants declared as i8)
println!("{}", cakes+pastries); // works because cakes is inferred as u8
let biscuits: u16 = 12;
// println!("{}", cakes+biscuits); !! doesn't work since cakes is now u8 after line 3
// println!("{}", pastries+biscuits); !! type mismatch!
println!("{}", pastries as u16 + biscuits); // explicit casting by =as=
let number_32: f32 = 5.0; // default f64
```

Rust also has **architecture-dependent** types namely `isize` and `uszie` where the bitsize used is subject to the running machine. The variables declared so far are all **mutable** i.e. their value cannot be altered or updated, this can be changed by declaring the variables with an additional `mut` keyword, i.e. `let mut var = value`. There's also a `todo!` macro which acts as indication for unfinished code, **with intention** to finish it somewhere down the line like all my projects.

```rust
// Display the message "Hello, world!"
todo!("Display the message by using the println!() macro (will I ever do it?? hmm 🤔)");
```

Rust also has the concept of **variable shadowing** where a new variable that uses the name of an existing variable becomes the only accessible instance with that name, the old variable value ceases to be in the current scope anymore. Towards strings now, they can be declared in multiple ways.

```rust
let mut s = String::from("hello");
s = "hello string".to_string();
// format! macro can be used to compose strings
s = format!("{} and {} is {}", 1, 2, 1+2);
println!("{}",s);
```

A mutable string can be modified by using the `push_str` for a string or `push` method for a single character. There are also references to  immutable pieces of utf8 strings called **string slices** which can be declared as shown:

```rust
let slice = "Not a string but a &str";
let s2: &str = &s; // slice that is a reference to s.
```

Other primitive data types are `bool`, `char` which is equivalent to `u32` (21 bits +11 padding bits).


### Tuples, Structs and Enums {#tuples-structs-and-enums}

Tuples are groupings of values of different types into a compound value. Its data type is defined by the sequence of data types of elements. Also tuples are immutable.

```rust
let tuple_e = ('E', 5i32, true); // type signature: (char, i32, bool)
println!("Is {} the {}th letter of the alphabet? {}", tuple_e.0, tuple_e.1, tuple_e.2);
```

A struct is a type that's composed of other types. To use a struct, first it must be defined with data type for each of its field and then its instance can be created for use.


### Functions {#functions}

Functions can be created using the `fn` keyword and return types specified by following argument list with `-> retType` .

```rust
fn print_hello(name: &str) -> u32{
    println!("Hello, {}!", name);
    return 1; // or simply =1=
}
```


### Conditionals {#conditionals}


### Loops and Hash Maps {#loops-and-hash-maps}


## Error Handling {#error-handling}


## Memory Management {#memory-management}


## Generics {#generics}


## Modules, Packages &amp; Crates {#modules-packages-and-crates}


## Automated Tests {#automated-tests}


## To-do list {#to-do-list}


## References {#references}

1.  [Why is Rust so popular?](https://stackoverflow.blog/2020/01/20/what-is-rust-and-why-is-it-so-popular/)
2.  [Rust - First Steps](https://docs.microsoft.com/en-us/learn/paths/rust-first-steps/?source=learn)
3.  [300 seconds of Rust](https://www.youtube.com/playlist?list=PLwhLlO5Vugx6KCwTpW_4fUeES2jdkDSW9)
4.  [Writing an OS in Rust](https://os.phil-opp.com/)
