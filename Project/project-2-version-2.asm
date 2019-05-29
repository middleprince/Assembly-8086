;主要的任务程序有4个模块，每个模块用‘=’分割，每个模块里面可能调用一些子程序，这些子程序用'-'分割
code segment 		;该程序段为安装程序
	assume cs:code
start:
	mov ax,code1 	;将第二个程序段放进软盘1扇区
	mov es,ax
	mov bx,0

	mov ah,3
	mov al,1
	mov ch,0
	mov cl,1
	mov dh,0
	mov dl,0
	int 13h

	mov ax,code2 	;将第三个程序段放进软盘的2~17扇区
	mov es,ax
	mov bx,0

	mov ah,3
	mov al,15
	mov ch,0
	mov cl,2
	mov dh,0
	mov dl,0
	int 13h

	mov ax,4c00h
	int 21h
code ends

code1 segment 		;这一个程序段为引导程序，负责将任务程序段加载进内存2000:0的位置并跳转到该位置执行程序
	assume cs:code1
	mov ax,2000h
	mov es,ax
	mov bx,0

	mov ah,2
	mov al,15
	mov ch,0
	mov cl,2
	mov dh,0
	mov dl,0
	int 13h

	mov ax,2000h
	push ax
	mov ax,0
	push ax
	retf

	mov ax,4c00h
	int 21h
code1 ends

code2 segment 		;主要的任务程序段
	assume cs:code2
	jmp start2
	s1: db '1) reset pc','$'
	s2: db '2) start system','$'
	s3: db '3) clock','$'
	s4: db '4) set clock','$'
	s:  dw offset s1, offset s2, offset s3, offset s4
	tp:	db 9,8,7,4,2,0
	printCache:	db 100 dup(0)
start2:
	call showCmd
	
;=======================引导现有的系统==========================================
startSys:
	push ax
	push es
	push bx
	push cx
	push dx
	call clearScreen

	mov ax,0
	mov es,ax
	mov bx,7c00h

	mov ah,2
	mov al,1
	mov ch,0
	mov cl,1
	mov dh,0
	mov dl,80h
	int 13h

	mov ax,0
	push ax
	mov ax,7c00h
	push ax
	retf

	pop dx
	pop cx
	pop bx
	pop es
	pop ax
	ret

;=======================重启计算机===================================================
restart:
	call clearScreen
	mov ax,0ffffh
	push ax
	mov ax,0
	push ax
	retf

;========================设置系统时间================================================
setTime:
	call clearScreen
	call getstr 	;用户要输入字符串，如果要将当前时间修改为16年3月20号9时12分30秒，则输入160320091230

	push cs
	pop	es
	mov si,offset printCache

	push cs
	pop ds
	mov di,offset tp

	mov cx,6
setTimeLop:
	push cx

	mov al,ds:[di]	;设定访问的CMOS端口
	out 70h,al

	mov ah,es:[si]
	mov al,es:[si+1]
	sub ah,30h
	sub al,30h

	and ah,00001111b
	and al,00001111b

	mov cl,4
	shl ah,cl
	or al,ah
	out 71h,al

	inc di
	add si,2

	pop cx
	loop setTimeLop

	call showCmd
	ret

;-------------------------从键盘读取用户输入的时间信息----------------------------------
getstr:
	push ax
getstrs:
	mov ah,0
	int 16h
	cmp al,20h
	jb nochar
	mov ah,0
	call charstack 		;将字符写入缓存
	mov ah,2
	call charstack
	jmp getstrs

nochar:
	cmp ah,0eh
	je backspace
	cmp ah,1ch
	je enter
	cmp ah,01h
	je backToMenu
	jmp getstrs

backToMenu:
	mov ah,3
	call charstack
	call showCmd
backspace:
	mov ah,1
	call charstack 		;字符弹出缓存
	mov ah,2
	call charstack
	jmp getstrs
enter:
	mov al,'$'
	mov ah,0
	call charstack
	mov ah,2
	call charstack
	pop ax
	ret

charstack:
	jmp short charstart

	table dw charpush,charpop,charshow,clearCache
	top dw offset printCache

charstart: 	;ds:[si]指向打印缓存
	push bx
	push dx
	push di
	push es
	push si
	push ds

	push cs
	pop ds
	mov si,offset printCache

	cmp ah,3
	ja sret
	mov bl,ah
	mov bh,0
	add bx,bx
	jmp word ptr table[bx]

charpush:
	mov si,top
	mov ds:[si],al
	inc top
	jmp sret

charpop:
	cmp top,offset printCache
	je sret
	dec top
	mov si,top
	mov al,ds:[si]
	jmp sret

charshow:
	mov bx,0b800h
	mov es,bx
	mov al,160
	mov ah,0
	mul dh
	mov di,ax
	add dl,dl
	mov dh,0
	add di,dx

	mov bx,offset printCache

charshows:
	cmp bx,top
	jne noempty
	mov byte ptr es:[di],' '
	jmp sret
noempty:
	mov al,ds:[bx]
	mov es:[di],al
	mov byte ptr es:[di+2],' '
	inc bx
	add di,2
	jmp charshows
	jmp sret

clearCache:
	mov top,offset printCache

sret:
	pop ds
	pop si
	pop es
	pop di
	pop dx
	pop bx
	ret

;=======================显示动态时间模块=============================================================
showDyTime:
	call clearScreen
showDyTimeLoop:
	call showTime
	jmp showDyTimeLoop
	ret

;-------------------------显示时间(静态),es:[si]指向端口中时间信息的位数---------------------
showTime:
	push es
	push si
	push ds
	push di
	push cx
	push dx

	push cs
	pop es
	mov si,offset tp

	push cs
	pop ds
	mov di,offset printCache 	;ds:[di]指向打印缓存，以便将时间信息打印出来

	mov cx,3
timelop0:
	mov dl,'/'
	call getTime
	add di,3
	inc si
	loop timelop0

	mov byte ptr ds:[di-1],0
	mov byte ptr ds:[di],0
	inc di

	mov cx,3
timelop1:
	mov dl,':'
	call getTime
	add di,3
	inc si
	loop timelop1
	
	mov byte ptr ds:[di-1],'$'

	mov dh,5
	mov dl,30
	push cs
	pop ds
	mov si,offset printCache
	call printStr

	mov ah,1
	int 16h

	cmp al,1bh 		;这里不能判断扫描码，因为先前已经给ah赋值1
	je pressEsc
	cmp ah,3bh
	je pressF1
	jmp showTimeRet

pressEsc:
	call showCmd
	jmp showTimeRet
pressF1:
	mov ah,0
	int 16h
	mov ax,0b800h
	mov es,ax
	mov si,1
	mov cx,2000
changeColor:
	inc byte ptr es:[si]
	add si,2
	loop changeColor

showTimeRet:
	pop dx
	pop cx
	pop di
	pop ds
	pop si
	pop es
	ret

;-----------------------子程序获得一个端口上的时间信息，并将其压入打印缓存---------------------------------------
getTime:
	push ax
	push cx

	mov al,es:[si]
	out 70h,al
	in al,71h

	mov ah,al
	mov cl,4
	shr al,cl
	and ah,00001111b

	add ah,30h
	add al,30h

	mov ds:[di],ax
	mov ds:[di+2],dl

	pop cx
	pop ax
	ret


;-------------------------显示指令字符串模块，调用printStr, ds:[di]指向字符串入口地址---------------------------
showCmd:
	push si
	push di
	push ds
	push dx
	push cx

	call clearScreen

	mov di,offset s
	push cs
	pop ds
	mov dh,10
	mov dl,30
	mov cx,4
showlop:
	mov si,ds:[di]
	call printStr
	inc dh
	add di,2
	loop showlop
inputCmd:
	mov ah,0 			;等待键盘输入
	int 16h

	cmp ah,02h
	je func1
	cmp ah,03h
	je func2
	cmp ah,04h
	je func3
	cmp ah,05h
	je func4
	jmp inputCmd 		;如果不是这几种指令的话就重新输入

func1:
	call restart
	jmp showCmdRet
func2:
	call startSys
	jmp showCmdRet
func3:
	call showDyTime
	jmp showCmdRet
func4:
	call setTime

showCmdRet:
	pop cx
	pop dx
	pop ds
	pop di
	pop si
	ret

;-----------------------清除屏幕子程序-------------------------------------------------------------------
clearScreen:
	push ax
	push es
	push si
	push cx

	mov ax,0b800h
	mov es,ax
	mov si,0
	mov cx,2000
clearlop:
	mov byte ptr es:[si],0
	add si,2
	loop clearlop

	pop cx
	pop si
	pop es
	pop ax
	ret


;-----------------------显示字符串子程序，dh控制行，dl*2控制列，ds:[si]指向字符串----------------------------
printStr:
	push cx
	push ax
	push dx
	push di
	push es
	push si

	mov cl,160
	mov al,dh
	mul cl
	mov dh,0
	add ax,dx
	mov di,ax 	;求出在显存中的偏移

	mov ax,0b800h
	mov es,ax

print:
	mov al,ds:[si]
	cmp al,'$'
	je endPrint
	mov es:[di],al
	add di,2
	inc si
	jmp print

endPrint:
	pop si
	pop es
	pop di
	pop dx
	pop ax
	pop cx
	ret
code2 ends

end start