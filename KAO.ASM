
assume cs:code0

data segment
        db 'Hello Masm!'
data ends

code0 segment
        db 'Hello code0!'
start:
        mov bx,0

        mov ax,4c00h
        int 21h
code0 ends

code1 segment
        db 'Hello code1!'

        mov bx,1

        mov ax,4c00h
        int 21h
code1 ends
end start
