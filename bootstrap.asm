start: 
    mov ax, 07C0h   ; firmware loads bootloader from this magic location
    mov ds, ax	    ; as we are not able to directly assign to segment register

    mov si, title_string
    call print_string

    mov si, messege_string
    call print_string

    call load_kernel_from_disk 
    jmp 0900h:0000

load_kernel_from_disk: 
    mov ax, 0900h 
    mov es, ax
    mov ah, 02h		; reads the sector from hard disk and loads into memory
    mov al, 01h		; number of sectors that would be read
    mov ch, 0h		; number of the tracks that we would like to read
    mov cl, 02h		; number of the sectors that we would link to read
    mov dh, 0h		; is the head number 
    mov dl, 80h 	; type of disk that we want to read from 
    mov bx, 0h		; memory address that the content will be loaded into
    int 13h


    jc kernel_load_error

    ret

kernel_load_error: 
   mov si, load_string_error
   call print_string


   jmp $

print_string: 
    mov ah, 0Eh 

print_char: 
    lodsb

    cmp al, 0
    je printing_finished 

    int 10h

    jmp print_char

printing_finished: 
    mov al, 10d		; print new line 
    int 10h 


    ; Reading current cursor position 
    mov ah, 03h 
    mov bh, 0
    int 10h

    ; move the cursor to the beginning 
    mov ah, 02h 
    mov dl, 0
    int 10h 

    ret

title_string		db 'The Bootloader of 539kernal.', 0
messege_string 		db 'The kernal is loading...', 0
load_string_error	db 'The kernal cannot be loaded.', 0

times 510-($-$$) db 0
dw 0xAA55

