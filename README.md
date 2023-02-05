
# How to program assembly

**Making fizzbuzz in x86_64-assembly**

## Idea


Output:
```
1
2
fizz
4
buzz
...
14
fizzbuzz
16
...
```

Typical implementation:
```py
def fizzbuzz(n: int) -> str:
    if n % 15 == 0:
        return "fizzbuzz"
    elif n % 5 == 0:
        return "buzz"
    elif n % 3 == 0:
        return "fizz"
    else:
        return str(n)

for i in range(1, 101):
    print(fizzbuzz(i))
```

## Make it low level

The C programming language is a decent middle ground between expressiveness and low-level transparency.

```c
#include <stdio.h>

void fizzbuzz(int n)
{
    if (n % 15 == 0)
        puts("fizzbuzz\n");
    else if (n % 5 == 0)
        puts("buzz\n");
    else if (n % 3 == 0)
        puts("fizz\n");
    else
        printf("%d\n", n);
}

int main()
{
    for (int i = 1; i <= 100; ++i)
        fizzbuzz(i);
}
```

## Remove dependencies

```c
#include <stdio.h>

int ipow(int base, int exponent)
{
    if (exponent <= 0)
        return 1;
    if (exponent == 1)
        return base;
    int result = base;
    for (int i = 1; i < exponent; i++)
        result *= base;
    return result;
}

void puti(int value)
{
    _Bool has_printed = 0;
    for (int i = 10; i >= 0; --i) {
        int m = ipow(10, i);
        int v = value / m;
        value -= m * v;
        if (v != 0 || has_printed) {
            fputc(v + 48, stdout);
            has_printed = 1;
        }
    }
}

void fizzbuzz(int n)
{
    if (n % 15 == 0)
        fputs("fizzbuzz", stdout);
    else if (n % 5 == 0)
        fputs("buzz", stdout);
    else if (n % 3 == 0)
        fputs("fizz", stdout);
    else
        puti(%d", n);
    fputc('\n', stdout);
}

int main()
{
    for (int i = 1; i <= 100; ++i)
        fizzbuzz(i);
}
```

## Instructions and Registers

The main registers in x86-64 are `rax`, `rbx`, `rcx`, `rsi`, `rdi`, `rsp`, `rbp`, these are 64-bit registers [[1](#sources)].

Often they are used as 32-bit registers using their 32-bit accessors: `eax`, `ebx`, `ecx`, `esi`, `esp`, `ebp`.

## Bytes, words, double words and quad words.

A bit is either `0` or `1`. A byte is 8 bits.

On x86-64, a word is 2 bytes/16 bits.

A double word is 2 words/4 bytes/32 bits. Double that for a quad word.

## Call convention

Differs on platforms.

On x86-64 Linux, the calling convention is the following [[2](#sources)]:

A subroutine manages it's own stack.

The return value is returned in `rax`, if it's an integer.

The parameters are passed in `rdi`, `rsi`, `rdx`, `r10`, `r8`, `r9`, in that order, the rest are passed on the stack.

The C function:
```c
int add(int a, int b) {
    return a + b;
}
```

Roughly translates to the following assembly:
```x86asm
add:
    ; setup stack frame
    push rbp
    mov rbp, rsp
    sub rsp, 8 ; allocate 2 x 4-byte int

    ; move parameters onto the stack
    mov [rsp], edi
    mov [rsp + 4], esi

    ; load and add values
    mov eax, [rsp]
    add eax, [rsp + 4]

    ; result is now stored in eax
.return:
    ; deallocate stack frame and return
    mov rsp, rbp
    pop rbp
    ret
```

## Translate into assembly

## Sources

1. [CPU Registers x86-64 - OSDev Wiki](https://wiki.osdev.org/CPU_Registers_x86-64)
2. [Linux System Syscall Table (And calling convention) - ChromiumOS Docs](https://chromium.googlesource.com/chromiumos/docs/+/HEAD/constants/syscalls.md) 
3. [Compiler Explorer](https://godbolt.org/)

