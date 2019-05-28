;reset pc function

 				jmp rebootstart

 		rebootdata: dw 0,0

 				mov ax,cs
 				mov ds,ax
 				mov ax,offset rebootdata
 				mov bx,ax
 				mov word ptr [bx],0000h
 				mov word ptr [bx].2,0ffffh
 				call dword ptr [bx]

 			