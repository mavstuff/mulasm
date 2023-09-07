includelib ucrt.lib
includelib legacy_stdio_definitions.lib
includelib msvcrt.lib

option casemap:none

.data
real_a qword 3
real_b qword 4
real_ans qword ?

input_ans qword ?


fmtStrPrint db '%ld x %ld=?', 10, 0

fmtStrInput db '%ld', 0

fmtStrPrintOK db 'OK!', 10, 0
fmtStrPrintNotCorrect db 'NOT CORRECT! %ld', 10, 0

.code
externdef printf:proc
externdef scanf:proc
externdef _CRT_INIT:proc
externdef exit:proc
externdef rand:proc
externdef srand:proc
externdef time:proc


main proc
    ;int 3
    call _CRT_INIT
    push rbp
    mov rbp, rsp
    sub rsp, 32

go:
    
    xor rcx,rcx
    call time

    
    mov rcx, rax
    call srand


    call rand
    xor rdx,rdx
    mov rcx, 10
    div rcx
    inc rdx


    lea rsi, real_a
    mov [rsi], rdx


    call rand
    xor rdx,rdx
    mov ecx, 10
    div ecx
    inc rdx

    lea rsi, real_b
    mov [rsi], rdx

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


    lea rdx, input_ans
    lea rcx, fmtStrInput
    call scanf

    lea rsi, real_ans
    mov rcx, [rsi]
    lea rsi, input_ans
    mov rax, [rsi]

    cmp rcx, rax
    jne not_correct

    lea rcx, fmtStrPrintOK
    call printf     
    jmp done

not_correct:

    lea rdx, real_ans
    mov rdx, [rdx]
    lea rcx, fmtStrPrintNotCorrect
    call printf     


done:
    jmp go

    xor ecx, ecx ; the first argument for exit() is setting to 0
    call exit

    add rsp, 32
    pop rbp
main endp

end