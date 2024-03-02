.286
.model tiny
.code
org 100h



;----------------------------------------------------------
PASSWORD_LENGTH         equ 10          ; Length of password string
ENTER_SCAN_CODE         equ 1ch         ;
BACKSPACE_SCAN_CODE     equ 0eh         ;
CIPHER_STEP             equ 1           ; 
;----------------------------------------------------------



;----------------------------------------------------------
;----------------------------------------------------------
Start:          call ReadPassword
                call CheckPassword

                jmp ChooseAccess
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

                mov bx, offset typed_pwd

                ;----------------------
                ; Cycle to read letter and
                ; put it into typed_password
                ; until ENTER is pressed.
                ; Press BACKSPACE to erase letter.
                ;----------------------
ReadLetter:     ;----------------------
                ; Interrupts and BIOS services
                ; AH = 00h
                ; int 16h - read symbol
                ;----------------------
                mov ah, 00h
                int 16h                         ; read letter from keyboard

                cmp ah, ENTER_SCAN_CODE         ; if (AL == ENTER_SCAN_CODE)
                je EndReadLetter                ;       EndReadLetter;

                cmp ah, BACKSPACE_SCAN_CODE     ; if (AL != BACKSPACE_SCAN_CODE)
                jne PutLetter                   ;       PutLetter, BX++;

EraseLetter:    dec bx                          ; else EraseLetter, BX--;
                jmp ReadLetter

PutLetter:      mov [bx], al
                inc bx
                jmp ReadLetter

EndReadLetter:  ret
                endp
;----------------------------------------------------------
;----------------------------------------------------------



;----------------------------------------------------------
;
;
;
;
;----------------------------------------------------------
CheckPassword   proc

                mov si, offset typed_pwd                ; SI -> typed password
                mov di, offset reference_pwd            ; DI -> reference password

                push cs
                pop es                                  ; ES = CS

                mov cx, PASSWORD_LENGTH                 ; CX = PASSWORD_LENGTH, counter

DecipherSymbol: add byte ptr [si], CIPHER_STEP
                inc si
                loop DecipherSymbol
                
                sub si, PASSWORD_LENGTH
                mov cx, PASSWORD_LENGTH

                repe cmpsb

                cmp cx, 0                               ; if (cx != 0)
                jne EndCheckPassword                    ;       { EndCheckPassword; }
                                                        ; else  { access_function_address -> GrantAccess; }
                mov access_function_address, GrantAccess - ChooseAccess - 2

EndCheckPassword:
                ret
                endp
;----------------------------------------------------------
;----------------------------------------------------------



;----------------------------------------------------------
; String to print if access is granted
;----------------------------------------------------------
access_granted_str      db "ACCESS GRANTED$"
;----------------------------------------------------------

;----------------------------------------------------------
; String to print if access is denied
;----------------------------------------------------------
access_denied_str       db "ACCESS DENIED$"
;----------------------------------------------------------



;----------------------------------------------------------
; Function prints phrase "Access granted" and ends program
; Enter: none
; Exit:  none
; Destr: AX, DX
;----------------------------------------------------------
GrantAccess:    mov ah, 09                              ; DOS Fn 09h - Display text
                mov dx, offset access_granted_str       ; DX -> access_granted_str
                int 21h                                 ; print string

                mov ax, 4c00h                           ; DOS Fn 4ch - Terminate
                int 21h                                 ; Terminate
;----------------------------------------------------------
;----------------------------------------------------------



;----------------------------------------------------------
; Function prints phrase "Access denied" and ends program
; Enter: none
; Exit:  none
; Destr: AX, DX
;----------------------------------------------------------
DenyAccess:     mov ah, 09                              ; DOS Fn 09h - Display text
                mov dx, offset access_denied_str        ; DX -> access_denied_str
                int 21h                                 ; print string

                mov ax, 4c00h                           ; DOS Fn 4ch - Terminate
                int 21h                                 ; Terminate
;----------------------------------------------------------
;----------------------------------------------------------



;----------------------------------------------------------
; Self defining jump. If the password is correct, it jumps
; to GrantAccess, if not - to DenyAccess.
;----------------------------------------------------------
ChooseAccess:           db 0EBh
access_function_address dw DenyAccess - ChooseAccess - 2
;----------------------------------------------------------

;----------------------------------------------------------
; Password string from user
;----------------------------------------------------------
typed_pwd               db PASSWORD_LENGTH dup (0)
;----------------------------------------------------------

;----------------------------------------------------------
; Encrypted correct password
;----------------------------------------------------------
reference_pwd           db "MeowKitten$"
;----------------------------------------------------------



end             Start
