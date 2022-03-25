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


    ; mov rax, [rel n]
    ; mov rax, [rdi + 4]
    add rsp, [rel array_size]
    mov rax, [rax]
    ret