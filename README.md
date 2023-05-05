# tiger-rs
Rust implementation of the projects from the book Modern Compiler Implementation in ML

## Forked on 05/05/2023

Hi.
I was trying to build this and had a rough time.

I changed `llvm_asm!` macros to `asm!`, but I can't trust to have any real clue about those, even after reading some rust docs for both of them.
ATM I can't seem to pass more than half the built-in tests for tiger, there's some unaligned pointer access happening.
