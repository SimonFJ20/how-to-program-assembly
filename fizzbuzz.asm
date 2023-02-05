bits 64

global _start

section .data

fizz_str: db "fizz"
fizz_str_len: equ $ - fizz_str

buzz_str: db "buzz"
buzz_str_len: equ $ - buzz_str

new_line: db 10

section .text

_start:
    call main
    jmp exit

print_fizz:
    mov rax, 1
    mov rdi, 1
    mov rsi, fizz_str
    mov rdx, fizz_str_len
    syscall
    ret

print_buzz:
    mov rax, 1
    mov rdi, 1
    mov rsi, buzz_str
    mov rdx, buzz_str_len
    syscall
    ret

ipow:
    cmp esi, 0
    jne .exponent_not_0
    mov eax, 1
    ret
.exponent_not_0:
    cmp esi, 1
    jne .exponent_not_1
    mov eax, edi
    ret
.exponent_not_1:
    mov edx, 1
    mov r8d, edi
.loop:
    cmp edx, esi
    jl .loop_end
    imul r8d, edi
    inc edx
    jmp .loop
.loop_end:
    mov eax, r8d
    ret

print_int:
    push rbp
    mov rbp, rsp
    sub rsp, 18
    mov [rsp], edi
    mov byte [rsp + 16], 0
    mov dword [rsp + 4], 1
.loop:
    mov eax, [rsp + 4]
    cmp eax, 0
    jl .loop_end
    mov edi, 10
    mov esi, [rsp + 4]
    call ipow
    mov [rsp + 8], eax
    mov eax, [rsp]
    mov esi, [rsp + 8]
    cdq
    idiv esi
    mov [rsp + 12], eax
    mov eax, [rsp + 8]
    imul eax, [rsp + 12]
    sub [rsp], eax
    mov eax, [rsp + 12]
    mov dil, [rsp + 16]
    or al, dil
    cmp eax, 0
    je .if_end
    mov eax, [rsp + 12]
    add eax, 48
    mov [rsp + 17], al
    mov rax, 1
    mov rdi, 1
    lea rsi, [rsp + 17]
    mov rdx, 1
    syscall
.if_end:
    dec dword [rsp + 4]
    jmp .loop
.loop_end:
.return:
    mov rsp, rbp
    pop rbp
    ret

fizzbuzz:
    push rbp
    mov rbp, rsp
    sub rsp, 4
    mov dword [rsp], edi
    mov eax, [rsp]
    mov esi, 15
    cdq
    idiv esi
    cmp edx, 0
    jne .not_15
    push rdx
    call print_fizz
    call print_buzz
    pop rdx
    jmp .if_done
.not_15:
    mov eax, [rsp]
    mov esi, 5
    cdq
    idiv esi
    cmp edx, 0
    jne .not_5
    push rdx
    call print_buzz
    pop rdx
    jmp .if_done
.not_5:
    mov eax, [rsp]
    mov esi, 3
    cdq
    idiv esi
    cmp edx, 0
    jne .not_3
    push rdx
    call print_fizz
    pop rdx
    jmp .if_done
.not_3:
    mov edi, [rsp]
    call print_int
.if_done:
    mov rax, 1
    mov rdi, 1
    mov rsi, new_line
    mov rdx, 1
    syscall
.return:
    mov rsp, rbp
    pop rbp
    ret

main:
    mov rdi, 1
.loop:
    cmp rdi, 100
    jg .loop_end
    push rdi
    call fizzbuzz
    pop rdi
    inc rdi
    jmp .loop
.loop_end:
    ret

exit:
    mov rax, 60
    mov rdi, 0
    syscall
