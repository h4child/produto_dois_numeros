;
;                 _ _   _       _                                             
;                | | | (_)     | |                                            
; _ __ ___  _   _| | |_ _ _ __ | | ___     ___ ___  _ __ ___  _   _ _ __ ___  
;| '_ ` _ \| | | | | __| | '_ \| |/ _ \   / __/ _ \| '_ ` _ \| | | | '_ ` _ \ 
;| | | | | | |_| | | |_| | |_) | | (_) | | (_| (_) | | | | | | |_| | | | | | |
;|_| |_| |_|\__,_|_|\__|_| .__/|_|\___/   \___\___/|_| |_| |_|\__,_|_| |_| |_|
;                        | |                                                  
;                        |_|                                                  
;
;-----------------------------------------------------------------------------

;Procurar múltiplo comum entre dois números 
;abaixo de 1000 e positivo

;nasm -felf64 produtos.asm
;gcc -g -no-pie produtos.o

;github: 21/11/2020


section .data
    header_        db "Procurar a relação dos produtos sobre dois números",0AH,'\
ABAIXO',0
    text_input1     db 'número 1: ',0 
    text_input2     db 'número 2: ',0
    text_negative   db 'Números negativos e zero não podem!',0Ah, 0
    text_above      db 'acima de 1000 não pode!',0AH,0
    scanf_input     db '%ld',0
    multiple_single db '%ld - ',0
    text_multiple   db 'produtos iguais (%ld e %ld): {',0
    multiple_null   db  'não há valores relacionados  ',0
    end_multiple    db  08H,08H,08H,'} ',0Ah,0

section .text
global main
extern scanf
extern printf
extern malloc
extern puts
extern free
extern __fpurge
extern stdin

;função main
main: ;função
    push rbp
    mov  rbp, rsp

    sub  rsp, 48
    mov  qword [rbp-8], 0 ;number1
    mov  qword [rbp-16], 0 ;number2
    mov  qword [rbp-24], 0 ;endereço malloc, guarda multiplos
    mov  qword [rbp-32], 0 ;index malloc

    mov  rdi, header_
    call puts 

  input: ;number1
    mov  rdi, text_input1
    xor  rax, rax
    call printf ; call print "número 1: "
    mov  rdi, scanf_input
    lea  rsi, [rbp-8]
    xor  rax, rax
    call scanf ; call scanf recebe number1

    mov  rdi, [stdin]
    call __fpurge ;call fpurge, limpa buffer

    mov  rdi, [rbp-8]
    call negative_number ;função verifica se number1 é negativa
    cmp  rax, 1 ;retorna inválido 1 e válido 0
    je   input

    mov  rdi, [rbp-8]
    call less1000 ;call less1000, apenas menor que 1000
    cmp  rax, 1 ;retorna inválido 1 e válido 0
    je  input

  input2: ;number2
    mov  rdi, text_input2
    xor  rax, rax
    call printf ;call print "número 2: "

    mov  rdi, scanf_input
    lea  rsi, [rbp-16]
    xor  rax, rax
    call scanf ;call scanf number2

    mov  rdi, [stdin]
    call __fpurge ;call fpurge, limpa buffer

    mov  rdi, [rbp-16]
    call negative_number ;- call função verifica number2 negativo
    cmp  rax, 1
    je   input2

    mov  rdi, [rbp-16]
    call less1000 ;call less1000, apenas menor que 1000
    cmp  rax, 1
    je  input2


    mov  rdi, [rbp-8] ;number1
    mov  rsi, [rbp-16];number2
    call multiple ;call multiple

    mov  [rbp-24], rax ;retorna é o endereço malloc

    mov  rdi, text_multiple
    mov  rsi, [rbp-8] ;number1
    mov  rdx, [rbp-16] ;number2
    xor  rax, rax
    call printf ;text_multiple com number1 e number2

    mov  rcx, 0 ;index
    mov  qword rdx, [rbp-24] ;endereço do array rdx = [rbp-24](endereço)

    cmp  qword rdx, 0 ;compara se o valor retornado é NULL

    ja   loop_show ;loop_show extrai valor do array

    mov  rdi, multiple_null
    mov  rax, rax
    call printf ;multiple_null

    mov  rdi, end_multiple
    mov  rax, rax
    call printf ;end_multiple


    mov  rax, -1
    leave
    ret

  loop_show:
    mov  rdi, multiple_single
    mov  rsi, [rdx+rcx*8]
    xor  rax, rax
    call printf

    mov  qword rdx, [rbp-24]
    inc  qword [rbp-32]
    mov  rcx, qword [rbp-32]
    mov  rbx, qword [rdx+rcx*8]
    cmp  rbx, 0
    jne  loop_show

    mov  rdi, end_multiple
    xor  rax, rax
    call printf

    xor  rax, rax
    leave
    ret
;fim Função MAIN


;Função Multiple
multiple: ;Função
    push rbp
    mov  rbp, rsp

    sub  rsp, 72
    ;variáveis locais
    mov  [rbp-8], rdi ;------ number1
    mov  [rbp-16], rsi ;----- number2
    mov  qword [rbp-24], 0 ;- endereço malloc
    mov  qword [rbp-32], 0 ;- incremento number1
    mov  qword [rbp-40], 0 ;- incremento number2
    mov  qword [rbp-48], 0 ;- resultado number1
    mov  qword [rbp-56], 0 ;- resultado number2
    mov  qword [rbp-64], 0 ;- index malloc


    mov  edi, 21
    imul edi, 8
    call malloc ;rax = malloc(rdi[21*8])
    mov  qword [rax], 0
    mov  qword [rbp-24], rax

  loop_multiple1: ;loop_multiple1

    inc  qword [rbp-32]
    mov  rax, qword [rbp-32]
    mul  qword [rbp-8]
    mov  [rbp-48], rax ;---- [rbp-48] resultado multiplicação number1
    mov  r11, rax   ;rax é usado implícito, portanto passa resultado r11
    mov  qword [rbp-40], 0

  loop_multiple2: ;loop dentro do loop_multiple1
    inc  qword [rbp-40]
    mov  rax, qword [rbp-40]
    mul  qword [rbp-16]
    mov rdx, rax    ;--- rdx resultado multiplicação number2

    cmp  rdx, r11 ;verifique se produtos são iguais
    jne  cmp_nultiple2 ;

    mov  rbx, [rbp-24] ;endereço para rbx

    mov  rcx, qword [rbp-64] ;index do array dos produtos
    mov  [rbx+rcx*8], r11

    inc  qword [rbp-64]
    mov  rcx, qword [rbp-64]
    jmp  cmp_multiple1

  cmp_nultiple2:
    cmp  qword [rbp-40], 20
    jl   loop_multiple2

  cmp_multiple1:
    cmp  qword [rbp-32], 20
    jb   loop_multiple1

    mov  rax, qword [rbp-24] ;endereço do ponteiro para RAX
    cmp  qword [rax], 0 ;verifica se tem dados no array
    jne  has

    mov  rdi, rax
    call free ;libere ponteiro

    mov rax, 0 ;return NULL
    leave
    ret

  has:
    mov rcx, qword [rbp-64]
    mov qword [rax+rcx*8], 0 ;último é um NULL

    mov  rax, [rbp-24] ;return endereço do array
    leave
    ret

;fim Função Multiple


;função less1000
less1000:
    push rbp
    mov  rbp, rsp
    sub  rsp, 8

    mov  [rbp-8], rdi
    mov  rax, [rbp-8]

    cmp  rax, 1000
    ja   text_above1000 ;se rax for maior que 1000 text_above1000

    xor  rax, rax ;zerar retorno
    leave
    ret

  text_above1000:
    mov  rdi, text_above
    xor  rax, rax
    call printf

    mov  rax, 1 ;return 1
    leave
    ret

negative_number:

    push rbp
    mov  rbp, rsp
    sub  rsp, 16

    mov  [rbp-8], rdi
    mov  rax, [rbp-8]

    cmp  rdi, 0 ;----- destination: rdi|source: 0
    jle   print_negative ;- destination <= source

    mov rax, 0 ;return 0
    leave
    ret

  print_negative:
    mov  rdi, text_negative
    xor  rax, rax
    call printf

    mov  rax, 1 ;return 1
    leave
    ret
