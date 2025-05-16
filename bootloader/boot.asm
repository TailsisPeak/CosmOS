BITS 16 ; Austin help me please, I'm suffering.
ORG 0x7C00

start:
    cli                     ; Disable interrupts

    
    call enable_a20

    ; Load GDT
    lgdt [gdt_descriptor]

    ; Enter protected mode
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    
    jmp 0x08:protected_mode_start

; ---------------------------

gdt_start:
    dq 0x0000000000000000                
    dq 0x00CF9A000000FFFF                
    dq 0x00CF92000000FFFF                
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1           ; Size of GDT - 1
    dd gdt_start                        ; Base address of GDT

; ---------------------------
enable_a20:
    in al, 0x92
    or al, 2
    out 0x92, al
    ret

; ---------------------------
BITS 32
protected_mode_start:
    ; dear god help me
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov esp, 0x9FC00

    
    sti

    ; Print message 
    mov esi, msg               ; Point to string
    mov edi, 0xB8000          ; Video memory start

.print_loop:
    lodsb                     
    test al, al               
    jz .done
    mov [edi], al             
    mov byte [edi+1], 0x0F    
    add edi, 2               
    jmp .print_loop

.done:
    jmp $

msg db "CosmOS kernel running", 0 ; Finally jesus fucking christ

; Fill rest of 512 bytes with zeros
TIMES 510 - ($ - $$) db 0
DW 0xAA55                      ; Boot sign
