.286
.model tiny
.code
org 100h



;----------------------------------------------------------
;----------------------------------------------------------
Start:
;----------------------------------------------------------
;----------------------------------------------------------



;----------------------------------------------------------
; Function prints phrase "Access granted" and ends program
; Enter: none
; Exit:  none
; Destr: AX, DX
;----------------------------------------------------------
GrantAccess     proc

                mov ah, 09                              ; DOS Fn 09h - Display text
                mov dx, offset access_granted_str       ; DX -> access_granted_str
                int 21h                                 ; print string

                mov ax, 4c00h                           ; DOS Fn 4ch - Terminate
                int 21h                                 ; Terminate

                ret
                endp
;----------------------------------------------------------
;----------------------------------------------------------



;----------------------------------------------------------
; Function prints phrase "Access denied" and ends program
; Enter: none
; Exit:  none
; Destr: AX, DX
;----------------------------------------------------------
DenyAccess      proc

                mov ah, 09                              ; DOS Fn 09h - Display text
                mov dx, offset access_denied_str        ; DX -> access_denied_str
                int 21h                                 ; print string

                mov ax, 4c00h                           ; DOS Fn 4ch - Terminate
                int 21h                                 ; Terminate

                ret
                endp
;----------------------------------------------------------
;----------------------------------------------------------



;----------------------------------------------------------
; Function read symbols from keyboard in a loop and places
; them in stack until ENTER is pressed. Press BACKSPACE to
; pop letter from stack (if you typed wrong letter).
; Enter: none
; Exit:  BX = number of letters, stack with letters
; Destr: AX, BX
;----------------------------------------------------------
ReadPassword    proc

                ;----------------------
                ; Interrupts and BIOS services
                ; AH = 00h
                ; int 16h - read symbol
                ;----------------------
                xor ax, ax
                mov ah, 00h

                xor bx, bx                      ; BX is a letter counter

                ;----------------------
                ; Cycle to read letter
                ; and push it to stack
                ; until ENTER is pressed.
                ; Press BACKSPACE to pop letter.
                ;----------------------
ReadLetter:     int 16h                         ; read letter from keyboard
                cmp al, ENTER_SCAN_CODE         ; if (AL == ENTER_SCAN_CODE)
                je EndReadLetter                ;       EndReadLetter;

                cmp al, BACKSPACE_SCAN_CODE     ; if (AL != BACKSPACE_SCAN_CODE)
                jne PushLetter                  ;       PushLetter, BX++;

PopLetter:      pop ax                          ; else PopLetter, BX--;
                dec bx
                jmp ReadLetter

PushLetter:     push ax
                inc bx
                jmp ReadLetter

EndReadLetter:  ret
                endp
;----------------------------------------------------------
;----------------------------------------------------------








;----------------------------------------------------------
access_granted_str      db "ACCESS GRANTED$"
;----------------------------------------------------------

;----------------------------------------------------------
access_denied_str       db "ACCESS DENIED$"
;----------------------------------------------------------

;----------------------------------------------------------
reference_pwd           db "0123456789"
;----------------------------------------------------------

end             Start
