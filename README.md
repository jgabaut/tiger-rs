# tiger-rs
Rust implementation of the projects from the book Modern Compiler Implementation in ML

## Forked on 05/05/2023

Hi.
I was trying to build this and had a rough time.

I switched toolchain to nightly since cargo whined about some feature not being available on stable.

I also changed `llvm_asm!` macros to `asm!`, but I can't trust to have any real clue about those, even after reading some rust docs for both of them.

ATM I can't seem to pass more than half the built-in tests for tiger, there's some unaligned pointer access happening.

See examples: 
- [llvm_asm lib](https://dev-doc.rust-lang.org/beta/unstable-book/library-features/llvm-asm.html)
- [asm rust by example](https://doc.rust-lang.org/nightly/rust-by-example/unsafe/asm.html)

Or just the doc pages:
- [llvm_asm on rustdoc](https://dev-doc.rust-lang.org/beta/core/macro.llvm_asm.html)
- [asm on rustdoc](https://doc.rust-lang.org/stable/core/arch/macro.asm.html)

