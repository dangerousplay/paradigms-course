
# Exercise 1 - Simple math program in two different languages

<!-- TOC -->
* [Exercise 1 - Simple math program in two different languages](#exercise-1---simple-math-program-in-two-different-languages)
  * [Vlang](#vlang)
  * [nim](#nim)
  * [Challenges](#challenges)
    * [V lang](#v-lang)
    * [Nim](#nim-1)
<!-- TOC -->

In this assignment we should write two simple math programs in one language that we know and another one in one language that we don't know.
The program is a simple math expression parser and evaluator with support for the following operations:

- `*` - Multiply
- `/` - Divide
- `+` - Sum
- `-` - Subtract
- `^` - Pow

## Vlang

Compiling and running the program:

```shell
$ cd vlang
$ v run main.v
```

## nim

Compiling and running the program:

```shell
$ cd nim
$ nim r main.nim
```

## Challenges

### V lang
The main challenge to write the **V lang** version was understanding the **error handling** and the **control flow**.
V is very similar to Golang, it's easy to learn and to understand.

### Nim

The main challenge for the nim implementation was the **function declaration order**.
The function called in a given block should be declared **before the invocation**. 
Due to the algorithm being implemented as a sequence of fuctions that are connected and **call each other**, the functions are declared inside the main procedure `e`.
Due to how Nim manages memory, the function `evaluate` that receives callback functions as arguments, had their signature changed to pass the `Evaluator` type as an argument.
