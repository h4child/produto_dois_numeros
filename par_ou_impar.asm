;
;______                          _____                           
;| ___ \                        |_   _|                          
;| |_/ __ _ _ __    ___  _   _    | | _ __ ___  _ __   __ _ _ __ 
;|  __/ _` | '__|  / _ \| | | |   | || '_ ` _ \| '_ \ / _` | '__|
;| | | (_| | |    | (_) | |_| |  _| || | | | | | |_) | (_| | |   
;\_|  \__,_|_|     \___/ \__,_|  \___|_| |_| |_| .__/ \__,_|_|   
;                                              | |               
;                                              |_|               
;-----------------------------------------------------------------

;Saber se número é par ou ímpar

;nasm -felf64 par_e_impar.asm
;gcc -g -no-pie par_e_impar.o


;echo $?
;return 1 ---> valor inválido


;github: 21/11/2020

section .data

    text_scanf  db '%ld',0
    text_zero   db 'Pode se dizer que zero é par, porém não iremos afirmar isso neste algoritmo',0
    text_impar  db 'número %ld é impar',0AH,0
    text_par    db 'número %ld é par',0AH,0

section .text
global main
extern printf
extern scanf
extern puts

main:
    push  rbp
    mov   rbp, rsp
    sub   rsp, 16

    mov   qword [rbp-8], 0

    ;input valor
    mov   rdi, text_scanf
    lea   rsi, [rbp-8]
    xor   rax, rax
    call  scanf

    cmp   qword [rbp-8], 0
    jne   sem_zero

;[rbp-8] = 0
    mov   rdi, text_zero
    call puts

    mov  rax, 1 ;return 1
    leave
    ret

  sem_zero:
    mov  rdx, 1
    test rdx, [rbp-8]
    jne impar

    mov  rdi, text_par
    mov  rsi, [rbp-8] 
    call printf

    xor  rax, rax
    leave
    ret

  impar:
    mov  rdi, text_impar
    mov  rsi, [rbp-8] 
    call printf

    xor  rax, rax
    leave
    ret
