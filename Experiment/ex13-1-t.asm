; 实验13-1 测试代码
; 测试int 7ch 中断。
;show strings by us  int 7ch.progam int 7ch to achive the function
assume cs:code

data segment 
	db "welcome to masm !",0
data ends

code segment
	start:mov dh,10				;dh rows ,dl column,cl colors,ds:si point to the head of the strings
	mov dl,10
	mov cl,2
	mov ax,data
	mov ds,ax
	mov si,0
	int 7ch
	mov ax,4c00h
	int 21h
code ends

end start