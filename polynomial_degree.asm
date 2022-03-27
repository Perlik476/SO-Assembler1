global polynomial_degree

section .bss

n: resq 1
number_of_segments: resq 1
array_size_bytes: resq 1
array_size_bites: resq 1

section .text

polynomial_degree: ; tablica y w rdi, rozmiar tablicy n w rsi
    mov eax, esi
    mov [rel n], eax

    ; potrzeba do (n + 32) bitów do zapisu liczb, number_of_segments to liczba 64-bitowych segmentów, która mieści (n + 32) bity.
    lea rax, [rax + 32]
    shr rax, 6
    lea rax, [rax + 1]
    mov [rel number_of_segments], rax

    mov rax, [rel number_of_segments]
    shl rax, 3
    mul QWORD [rel n]
    mov [rel array_size_bites], rax
    shr rax, 3
    mov [rel array_size_bytes], rax

    sub rsp, [rel array_size_bites] ; zajmujemy miejsce na tablicę liczb na stosie
    mov rax, rsp
    mov rcx, [rel array_size_bytes]

array_all_zeros: ; zerujemy tablicę
    mov QWORD [rax], 0
    lea rax, [rax + 8]
    loop array_all_zeros

    mov rcx, [rel n]
    mov r11, [rel number_of_segments]
    mov rax, rsp

move_array: ; przenosimy zawartość tablicy y w odpowiednie miejsca utworzonej tablicy
    push rcx

    ; przenosimy liczbę z tablicy y do pierwszego segmentu odpowiedniego miejsca w tablicy na stosie
    mov r8d, [rdi]
    movsx r10, r8d
    mov [rax], r10

    cmp QWORD [rax], 0 ; jeśli wartość liczby jest dodatnia, to nie trzeba zmieniać pozostałych segmentów odpowiadających za tę liczbę
    jge move_array_next_step

    lea rdx, [rax + 8]
    mov rcx, [rel number_of_segments]
    sub rcx, 1
    jz move_array_next_step

negative_loop: ; jeśli liczba jest ujemna, to bity w pozostałych segmentach odpowiadających tej liczbie trzeba ustawić na same jedynki
    mov QWORD [rdx], -1
    lea rdx, [rdx + 8]
    loop negative_loop

move_array_next_step: ; przesuwamy wskaźniki do następnych pozycji i powtarzamy pętlę
    lea rax, [rax + 8 * r11]
    lea rdi, [rdi + 4]

    pop rcx
    loop move_array

    mov r9, [rel array_size_bytes] ; aktualny rozmiar tablicy, w kolejnych iteracjach będzie się zmniejszać o tyle, ile miejsca zajmuje jedna liczba w tablicy, tj. number_of_segments

    ; w r11 jest aktualnie number_of_segments, więc 8 * r11 jest wartością, o którą trzeba przesunąć wskaźnik, by dostać się do kolejnej liczby w tablicy
    lea r10, [r9 + 8 * r11]

    mov rcx, r9
    mov rsi, -1 ; w rsi będzie trzymany wynikowy stopień wielomianu
    mov rdi, [rel n]

    mov rax, rdi
    mul QWORD [rel number_of_segments]
    mov rcx, rax

    mov rax, rsp

    cmp rcx, 0
    je end

    jmp check_zeros_array

subtract:
    push rcx
    mov rcx, [rel number_of_segments]
    clc

subtract_two:
    mov rdx, [r10]
    sbb QWORD [rax], rdx
    lea rax, [rax + 8]
    lea r10, [r10 + 8]

    loop subtract_two

    pop rcx
    loop subtract

    mov rax, rsp
    mov rcx, r9
    
check_zeros_array:
    cmp QWORD [rax], 0
    jne non_zero
    lea rax, [rax + 8]
    loop check_zeros_array
    jmp end

non_zero:
    sub r9, [rel number_of_segments]
    sub rdi, 1
    mov rcx, rdi
    lea rsi, [rsi + 1]
    cmp rcx, 0
    je end
    mov rax, rsp
    lea r10, [rax + 8 * r11]
    jmp subtract

end:
    mov rax, rsi

    add rsp, [rel array_size_bites]
    ret