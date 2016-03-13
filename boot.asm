;;; nasm -f bin -o boot.bin boot.asm
;;; qemu -hda boot.bin
org 7C00H                      ; the program will be loaded at 7C00H

start:
  mov eax, string_start
  mov ch, 1                    ; ch contains color of text
  mov ebx, 0B8000H + 718H      ; B8000H is VGA memory
                               ; 718H is offset to approx center

print:
  mov cl, [eax]                ; load char into cl
  mov [ebx], cx                ; store [color:char] from cx into VGA
  add ch, 1                    ; change color to (ch+1) mod 16
  and ch, 0x0F
  add eax, 1                   ; advance string pointer
  add ebx, 2                   ; advance VGA pointer
  cmp eax, string_end          ; until the end of string
  jg stop
  jmp print

stop:
  jmp stop                     ; infinite loop after printing

  string_start db 'My colorful new OS!'
  string_end equ $

  times 510-($-$$) db 0        ; pad remainder of boot sector with 0s
  dw 0xAA55                    ; standard PC boot signature
