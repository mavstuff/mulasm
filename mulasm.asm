includelib ucrt.lib
includelib legacy_stdio_definitions.lib
includelib msvcrt.lib

option casemap:none

.data
real_a qword 3
real_b qword 4
real_ans qword ?

input_ans qword ?


fmtStrPrint byte '%ld x %ld=?', 10, 0

fmtStrInput byte '%ld', 0

fmtStrPrintOK byte 'OK!', 10, 0
fmtStrPrintNotCorrect byte 'NOT CORRECT! %ld', 10, 0

.code
externdef printf:proc
externdef scanf:proc
externdef _CRT_INIT:proc
externdef exit:proc
externdef rand:proc
externdef srand:proc
externdef time:proc


main proc
    call _CRT_INIT
    push rbp
    mov rbp, rsp

go:
    sub rsp, 32
    xor ecx,ecx
    call time
    
    sub rsp, 32
    mov ecx, eax
    call srand


    call rand
    xor rdx,rdx
    mov ecx, 0AH
    div ecx
    inc rdx


    lea rsi, real_a
    mov [rsi], rdx


    call rand
    xor rdx,rdx
    mov ecx, 04H
    div ecx
    inc rdx

    lea rsi, real_b
    mov [rsi], rdx

    sub rsp, 32
    lea rsi, real_a
    mov r8, [rsi]
    lea rsi, real_b
    mov rdx, [rsi]
    lea rcx, fmtStrPrint
    call printf

    lea rsi, real_a
    mov rax, [rsi]
    lea rsi, real_b
    mov rcx, [rsi]

    mul rcx
    lea rsi, real_ans
    mov [rsi], rax


    sub rsp, 32
    lea rdx, input_ans
    lea rcx, fmtStrInput
    call scanf

    lea rsi, real_ans
    mov rcx, [rsi]
    lea rsi, input_ans
    mov rax, [rsi]

    cmp rcx, rax
    jne not_correct

    sub rsp, 32
    lea rcx, fmtStrPrintOK
    call printf     
    jmp done

not_correct:

    sub rsp, 32
    lea rdx, real_ans
    mov rdx, [rdx]
    lea rcx, fmtStrPrintNotCorrect
    call printf     


done:


    jmp go


    xor ecx, ecx ; the first argument for exit() is setting to 0
    call exit
main endp

end