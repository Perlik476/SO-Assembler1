gcc -c -Wall -Wextra -std=c17 -O2 -o polynomial_degree_c.o polynomial_degree_example.c
nasm -f elf64 -w+all -w+error -o polynomial_degree_asm.o polynomial_degree.asm
gcc -static -o polynomial_degree polynomial_degree_c.o polynomial_degree_asm.o
