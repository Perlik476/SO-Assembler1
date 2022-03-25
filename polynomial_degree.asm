global polynomial_degree

section .bss

n:      resq 1
number_of_segments: resq 1
stack_array_pointer: resq 1
mem_array_pointer: resq 1
array_size: resq 1

section .text

polynomial_degree:
    ; tablica y w rdi, rozmiar tablicy n w rsi
    mov eax, esi
    mov [rel n], eax
    mov [rel mem_array_pointer], rdi

    lea rax, [rax + 32]
    shr rax, 6
    lea rax, [rax + 1]
    mov [rel number_of_segments], rax

    mov [rel stack_array_pointer], rsp
    mov rax, [rel number_of_segments]
    mul QWORD [rel n]
    mov rcx, 8
    mul rcx
    mov [rel array_size], rax
    sub rsp, rax
    mov rax, rsp
    ; lea rsp, [rsp + 8 * rax]

array_all_zeros:  
    mov QWORD [rax], 0
    lea rax, [rax + 8]
    cmp rax, [rel stack_array_pointer]
    jne array_all_zeros

    mov rcx, [rel n]
    mov r9, [rel number_of_segments]
    mov rax, rsp

move_array:
    mov r8d, [rdi]
    movsx r10, r8d
    mov [rax], r10

    cmp QWORD [rax], 0
    jge non_negative

    cmp QWORD [rel number_of_segments], 1
    je non_negative

    mov rdx, rax
    lea rdx, [rdx + 8]
    mov rcx, [rel number_of_segments]
    sub rcx, 1

negative_loop:
    mov QWORD [rdx], -1
    lea rdx, [rdx + 8]
    loop negative_loop

non_negative:
    lea rax, [rax + 8 * r9]
    lea rdi, [rdi + 4]

    loop move_array

    mov rax, rsp
    ; add rax, 8
    mov rax, [rax]

    add rsp, [rel array_size]
    ret