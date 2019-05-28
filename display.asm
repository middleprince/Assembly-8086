;the univers function to display the content in ........$
;use si to deliver the content position
assume cs:code

code segment
display: 
            push ds 
            push di
            push es

            mov ax,cs
            mov ds,ax
            
            mov ax,0b800h
            mov es,ax
            mov di,160*4+40*2
            mov ah,1

circlep:     mov al,ds:[si]
            cmp al,'$'
            je outprint
            mov es:[di],ax
            inc di
            inc di
            inc si
            jmp circlep

outprint:   pop es
            pop di
            pop ds
            ret

code ends