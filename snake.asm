[org 0x0100]
jmp start
min: dw 4
secs: dw 0
ticks: dw 0
tick2: dw 0
tick3: dw 0
lives:dw 3
li: db 'life : '
time: db 'Time : '
snake: times 240 dd 0
direction:dw 0
current: dw 0
length: dw 20
count: dd 0
ex: dw 0
size: dw 0
randocr:dw 0
delay:dw 0
slow:dw 1100
seccs:dw 0
siold: dw 0
menu: dw 0
score:dw 0
wiiiiin:dw 0
endtick: dw 0
strr: db 'Welcome To Snake Game'
str2: db 'Press 1 for begginer level Press 2 for novice level Press 3 for Pro level'
win:db 'Congratulations You won'
lose:db 'You lost'
final: db 'your score is :'
sccore:db 'Score:'
sim:dw 1,4,10
freq:dw 600,1200,1800
shapes:db '#%&$0'
shlen:db 0
clrscr: 
push es
push ax
push cx
push di
push cs
pop ds
mov ax, 0xb800
mov es, ax ; point es to video base
xor di, di ; point di to top left column
mov ax, 0x0720 ; space char in normal attribute
mov cx, 2000 ; number of screen locations
cld ; auto increment mode
rep stosw ; clear the whole screen
pop di
pop cx
pop ax
pop es
ret
sound:
push bp
mov bp,sp
pusha
mov     al, 182         ; Prepare the speaker for the
out     43h, al         ;  note.
mov     ax, word[bp+6]    ; Frequency number (in decimal)
                                ;  for middle C.
out     42h, al         ; Output low byte.
mov     al, ah          ; Output high byte.
out     42h, al 
in      al, 61h         ; Turn on note (get value from                        ;  port 61h).
or      al, 00000011b   ; Set bits 1 and 0.
out     61h, al         ; Send new value.
mov     bx, [bp+4]         ; Pause for duration of note.
pause1:
mov     cx, 65535
pause2:
dec     cx
jne     pause2
dec     bx
jne     pause1
in      al, 61h         ; Turn off note (get value from                        ;  port 61h).
and     al, 11111100b   ; Reset bits 1 and 0.
out     61h, al         ; Send new value.
popa
pop bp
ret 4
printnum1: push bp
mov bp, sp
push es
push ax
push bx
push cx
push dx
push di
mov di, 80 ; load di with columns per row
mov ax, [bp+8] ; load ax with row number
mul di ; multiply with columns per row
mov di, ax ; save result in di
add di, [bp+6] ; add column number
shl di, 1 ; turn into byte count
mov ax, 0xb800
mov es, ax ; point es to video base
mov ax, [bp+4] ; load number in ax
cmp ax,10
jl less
mov bx, 10 ; use base 10 for division
mov cx, 0 ; initialize count of digits
nextdigit: mov dx, 0 ; zero upper half of dividend
div bx ; divide by 10
add dl, 0x30 ; convert digit into ascii value
push dx ; save ascii value on stack
inc cx ; increment count of values
cmp ax, 0 ; is the quotient zero
jnz nextdigit ; if no divide it again
nextpos: 
pop dx ; remove a digit from the stack
mov dh, 0x35 ; use normal attribute

mov [es:di], dx ; print char on screen

add di, 2 ; move to next screen location
loop nextpos ; repeat for all digits on stack
end5:
pop di
pop dx
pop cx
pop bx
pop ax
pop es
pop bp
ret 6
str22:
pusha
push cs
pop ds
mov ax, 0xb800
mov es, ax ; point es to video base
mov di,1620
mov ah,0x35
mov bx,lose
mov cx,8
l9:
mov al,[bx]
mov word[es:di],ax
inc bx
add di,2
loop l9
mov bx,final
mov cx,15
mov di,1780
l10:
mov al,[bx]
mov word[es:di],ax
inc bx
add di,2
loop l10
popa
ret
less:
push bx
push es
mov bx, 0xb800
mov es, bx ; point es to video base
mov bx,0x3530
add ax,bx
mov word[es:di],ax
mov word[es:di+2],0x3320
pop es
pop bx
jmp end5
buffer:
push cx
mov cx,0xffff
l200:
loop l200
mov cx,0xffff
l201:
loop l201
mov cx,0xffff
l202:
loop l202
pop cx
ret
terminate1:
call clrscr
push cs
pop ds
call str22
push 11
push 35
push word[cs:score]
call printnum1
add word[cs:endtick],1
cmp word[cs:endtick],91
je terminate
jmp ret2
terminate:
call clrscr
jmp ennd
increase:
sub word[cs:slow],200
mov word[cs:seccs],0
jmp hit
prinnt:
call printsnake
push word[cs:freq]
push word[cs:sim]
call sound
mov word[cs:delay],0
jmp retback
reset:
dec word[cs:lives]
cmp word[cs:lives],0
je terminate
jmp baxk
timer:
push ax
cmp word[cs:wiiiiin],1
je ret2
cmp word[cs:endtick],0
jne terminate1
add word[cs:delay],55
cmp word[cs:lives],0
je terminate1
cmp word[cs:min],-1
je reset
baxk:
add word[cs:seccs],55
cmp word[cs:seccs],20000
jge increase
hit:
inc word[cs:tick2]
add word[cs:tick3],3
mov ax,word[cs:slow]
cmp word[cs:delay],ax
jge prinnt
retback:
push cs
pop ds
mov ax, 0xb800
mov es, ax ; point es to video base
mov di,3860
mov ax,0x3530
add ax,word[cs:lives]
mov word[es:di],ax
add word[cs:ticks],55
cmp word[cs:ticks],1000
jge equal
ret2:
mov al, 0x20
out 0x20, al ; end of interrupt
pop ax
iret 
equal:
mov word[cs:ticks],0
dec word[cs:secs]
cmp word[cs:secs],-1
je equal2
ret1:
push 24
push 60
push word[cs:min]
call printnum1
push 24
push 62
push word[cs:secs]
call printnum1
jmp ret2
equal2:
dec word[cs:min]
mov word[cs:secs],59
jmp ret1



getloc:
push bp
mov bp,sp
pusha
mov ax,[ss:bp+6]
mov cl,80
mul cl
add ax,word[ss:bp+4]
shl ax,1
mov word[ss:bp+8],ax
popa
pop bp
ret 4

day:
push bp
mov bp,sp
pusha
push cs
pop ds
mov di,word[ss:bp+4]
cmp word[es:di],0x447c
je not1
cmp word[es:di],0x352a
je not1
cmp word[es:di],0x3540
je not1
cmp di,3680
jg not1
end50:
popa
pop bp
ret 2
not1:
mov word[cs:randocr],1
jmp end50

rng:
pusha
mov al,00
out 0x70,al
jmp d1
d1:
in al,0x71
mov ah,0
add ax,word[cs:tick2]
mov bx,ax
mov cl,80
div cl
mov al,ah
xor ah,ah
mov si,ax
mov ax,bx
mov cl,25
div cl
mov al,ah
xor ah,ah
mov di,ax
push 0
push di
push si
call getloc
pop di
mov ax,0xb800
mov es,ax
push di
call day
cmp word[cs:randocr],1
je noprint
mov bl,byte[cs:shlen]
mov bh,0
mov al,byte[cs:shapes+bx]
mov ah,0xba
mov word[es:di],ax
inc byte[cs:shlen]
cmp  byte[cs:shlen],5
jge againz
noprint:
popa
ret 
againz:
mov byte[cs:shlen],0
jmp noprint
initializing:
pusha
push cs
pop ds
mov ax,0xb800
mov es,ax
mov bx,snake
add bx,80
push 0
push 12
push 40
call getloc
pop di
mov word[cs:current],bx
mov word[cs:bx+2],di
mov word[cs:bx],0x3540
mov ax,word[cs:bx]
mov word[es:di],ax
mov cx,19
l1:
sub bx,4
sub di,2
mov word[cs:bx],0x352a
mov ax,word[cs:bx]
mov word[es:di],ax
mov word[cs:bx+2],di
loop l1
l50:
mov word[cs:randocr],0
call rng
cmp word[cs:randocr],1
je l50
popa
ret

venom:
push word[cs:freq+2]
push word[cs:sim+2]
call sound
add word[cs:size],4
add word[cs:length],4
add word[cs:score],10
cmp word[cs:length],240

jge won
l51:
mov word[cs:randocr],0
call rng
cmp word[cs:randocr],1
je l51
jmp eddy

won:
call clrscr
mov word[cs:wiiiiin],1
mov ax, 0xb800
mov es, ax ; point es to video base
mov di,1620
mov ah,0x35
mov bx,win
mov cx,23
l90:
mov al,[bx]
mov word[es:di],ax
inc bx
add di,2
loop l90
mov bx,final
mov cx,15
mov di,1780
l91:
mov al,[bx]
mov word[es:di],ax
inc bx
add di,2
loop l91
push 11
push 35
push word[cs:score]
call printnum1
call buffer
call buffer
call buffer
call buffer
call buffer
call buffer
call buffer
call buffer
call buffer
call buffer
call buffer
call buffer
call buffer
call buffer
call buffer
call buffer
call buffer
call buffer
call buffer
call buffer
call buffer
call buffer
call buffer
call buffer
jmp terminate
insert1:
call insert
jmp end1
insert:
pusha
dec word[cs:size]
mov bx,word[cs:current]
mov si,bx
mov ax,word[cs:bx]
mov di,word[cs:bx+2]
add bx,4
mov [cs:current],bx
mov word[cs:bx],ax
mov word[cs:bx+2],di
mov word[cs:si],0x352a
mov cx,word[cs:si]
mov dx,word[cs:siold]
mov word[cs:si+2],dx
mov ax,0xb800
mov es,ax
mov ax,word[cs:bx]
mov word[es:di],ax
mov di,dx
mov word[es:di],cx
popa
ret
left:
pusha
push cs
pop ds
mov bx,[cs:current]
mov ax,0xb800
mov es,ax
mov cx,word[cs:length]
mov si,word[cs:bx+2]
mov word[cs:siold],si
add word[cs:bx+2],2
call boundarychecks
cmp word[cs:ex],1
je nothing4
mov di,word[cs:bx+2]
cmp word[es:di],0xba30
je venom
cmp word[es:di],0xba23
je venom
cmp word[es:di],0xba24
je venom
cmp word[es:di],0xba25
je venom
cmp word[es:di],0xba26
je venom
eddy:
cmp word[cs:size],0
jg insert1
mov di,word[cs:bx+2]
mov ax,word[cs:bx]
mov word[es:di],ax

dec cx
l3:
sub bx,4
mov di,si
mov si,word[cs:bx+2]
mov word[cs:bx+2],di
mov ax,word[cs:bx]
mov word[es:di],ax
loop l3
mov word[es:si],0x3520
end1:
popa
ret
nothing4:
sub word[cs:bx+2],2
mov word[cs:ex],0
jmp end4

boundarychecks:
push ax
push cx
push bx
push di
mov ax,0xb800
mov es,ax
mov bx,word[cs:current]
mov di,word[cs:bx+2]
cmp word[es:di],0x447c
je l13
cmp word[es:di],0x352a
je l13
jmp end12
l13:
push word[cs:freq+4]
push word[cs:sim+4]
call sound
dec word[cs:lives]
mov word[cs:ex],1
end12:
pop di
pop bx
pop cx
pop ax
ret
insert4:
call insert
jmp end4
venom1:
push word[cs:freq+2]
push word[cs:sim+2]
call sound
add word[cs:size],4
add word[cs:length],4
add word[cs:score],10
cmp word[cs:length],240
jge won
l52:
mov word[cs:randocr],0
call rng
cmp word[cs:randocr],1
je l52
jmp eddy1
right:
pusha
push cs
pop ds
mov bx,[cs:current]
mov ax,0xb800
mov es,ax
mov cx,word[cs:length]
mov si,word[cs:bx+2]
mov word[cs:siold],si
sub word[cs:bx+2],2
call boundarychecks
 
cmp word[cs:ex],1
je nothing
mov di,word[cs:bx+2]
cmp word[es:di],0xba30
je venom1
cmp word[es:di],0xba23
je venom1
cmp word[es:di],0xba24
je venom1
cmp word[es:di],0xba25
je venom1
cmp word[es:di],0xba26
je venom1
eddy1:
cmp word[cs:size],0
jg insert4
mov di,word[cs:bx+2]
mov ax,word[cs:bx]
mov word[es:di],ax

dec cx
l7:
sub bx,4
mov di,si
mov si,word[cs:bx+2]
mov word[cs:bx+2],di
mov ax,word[cs:bx]
mov word[es:di],ax
loop l7
mov word[es:si],0x3520
end4:
popa
ret
nothing:
add word[cs:bx+2],2
mov word[cs:ex],0
jmp end4
insert3:
call insert
jmp end3

venom2:
push word[cs:freq+2]
push word[cs:sim+2]
call sound
add word[cs:size],4
add word[cs:length],4
add word[cs:score],10
cmp word[cs:length],240
jge won
l53:
mov word[cs:randocr],0
call rng
cmp word[cs:randocr],1
je l53
jmp eddy2
up:
pusha
push cs
pop ds
mov bx,[cs:current]
mov ax,0xb800
mov es,ax
mov cx,word[cs:length]
mov si,word[cs:bx+2]
mov word[cs:siold],si
sub word[cs:bx+2],160
call boundarychecks
cmp word[cs:ex],1
je nothing1
mov di,word[cs:bx+2]
cmp word[es:di],0xba30
je venom2
cmp word[es:di],0xba23
je venom2
cmp word[es:di],0xba24
je venom2
cmp word[es:di],0xba25
je venom2
cmp word[es:di],0xba26
je venom2
eddy2:
cmp word[cs:size],0
jg insert3
mov di,word[cs:bx+2]
mov ax,word[cs:bx]
mov word[es:di],ax

dec cx
l6:
sub bx,4
mov di,si
mov si,word[cs:bx+2]
mov word[cs:bx+2],di
mov ax,word[cs:bx]
mov word[es:di],ax
loop l6
mov word[es:si],0x3520
end3:
popa
ret
nothing1:
add word[cs:bx+2],160
mov word[cs:ex],0
jmp end3
venom3:
push word[cs:freq+2]
push word[cs:sim+2]
call sound
add word[cs:size],4
add word[cs:length],4
add word[cs:score],10
cmp word[cs:length],240
jge won
l54:
mov word[cs:randocr],0
call rng
cmp word[cs:randocr],1
je l54
jmp eddy3

insert2:
call insert
jmp end2
down:
pusha
push cs
pop ds
mov bx,[cs:current]
mov ax,0xb800
mov es,ax
mov cx,word[cs:length]
mov si,word[cs:bx+2]
mov word[cs:siold],si
add word[cs:bx+2],160
call boundarychecks
cmp word[cs:ex],1
je nothing2
mov di,word[cs:bx+2]
cmp word[es:di],0xba30
je venom3
cmp word[es:di],0xba23
je venom3
cmp word[es:di],0xba24
je venom3
cmp word[es:di],0xba25
je venom3
cmp word[es:di],0xba26
je venom3
eddy3:
cmp word[cs:size],0
jg insert2
mov di,word[cs:bx+2]
mov ax,word[cs:bx]
mov word[es:di],ax
dec cx
l5:
sub bx,4
mov di,si
mov si,word[cs:bx+2]
mov word[cs:bx+2],di
mov ax,word[cs:bx]
mov word[es:di],ax
loop l5
mov word[es:si],0x3520
end2:
popa
ret
nothing2:
sub word[cs:bx+2],160
mov word[cs:ex],0
jmp end2

printsnake:
pusha

cmp word[cs:direction],0
je rightleft
cmp word[cs:direction],1
je leftright
cmp word[cs:direction],2
je downup
cmp word[cs:direction],3
je updown

end0:

popa
ret
rightleft:
call left
jmp end0
leftright:
call right
jmp end0
downup:
call up
jmp end0
updown:
call down
jmp end0
count1:
inc word[cs:count]
jmp l11
kbisr:
push ax
push es
in al,0x60
mov bl,al
shl bl,1
jnc count1
l11:
cmp al,0x11
jne nextcmp1
mov ax,word[cs:direction]
cmp ax,3
je upp
mov word[cs:direction],2
   
jmp nomatch
nextcmp1:
cmp al,0x20
jne nextcmp2
mov ax,word[cs:direction]
cmp ax,1
je leftt
mov word[cs:direction],0
   
jmp nomatch
nextcmp2:
cmp al,0x1e
jne nextcmp3
mov ax,word[cs:direction]
cmp ax,0
je rightt
mov word[cs:direction],1
   
jmp nomatch
nextcmp3:
cmp al,0x1f
jne nomatch
mov ax,word[cs:direction]
cmp ax,2
je downn
mov word[cs:direction],3
   
nomatch:
call str1
pop es

mov al,0x20
out 0x20,al
pop ax
iret
upp:
mov word[cs:direction],3
   
jmp nomatch
downn:
mov word[cs:direction],2
   
jmp nomatch
leftt:
mov word[cs:direction],1
   
jmp nomatch
rightt:
mov word[cs:direction],0
   
jmp nomatch


str1:
pusha
push cs
pop ds
mov ax, 0xb800
mov es, ax ; point es to video base
mov di,3844
mov ah,0x35
mov bx,li
mov cx,7
l20:
mov al,[bx]
mov word[es:di],ax
inc bx
add di,2
loop l20
mov bx,time
mov cx,7
mov di,3940
l21:
mov al,[bx]
mov word[es:di],ax
inc bx
add di,2
loop l21
mov ah,0x35
mov bx,sccore
mov cx,6
mov di,3900
l10011:
mov al,[bx]
mov word[es:di],ax
inc bx
add di,2
loop l10011
push 24
push 38
push word[cs:score]
call printnum1
popa
ret
borders:
pusha
mov di,0
mov ax, 0xb800
mov es, ax ; point es to video base
xor di, di ; point di to top left column
mov ax, 0x3320 ; space char in normal attribute
mov cx, 2000 ; number of screen locations

cld ; auto increment mode
rep stosw ; clear the whole screen
mov ax,0x447c
mov cx,80
mov di,0
cld
rep stosw
mov di,3680
mov cx,80
cld
rep stosw
mov cx,33
mov si,160
mov di,318
l8:

mov word[es:di],ax
mov word[es:si],ax
add di,160
add si,160
loop l8

popa
ret

novice:
pusha
mov di,0
mov ax, 0xb800
mov es, ax ; point es to video base
xor di, di ; point di to top left column
mov ax, 0x3320 ; space char in normal attribute
mov cx, 2000 ; number of screen locations
cld ; auto increment mode
rep stosw ; clear the whole screen
mov ax,0x447c
mov cx,40
mov di,1000
cld
rep stosw
mov di,2920
mov cx,40
cld
rep stosw
mov cx,80
mov di,0
cld
rep stosw
mov di,3680
mov cx,80
cld
rep stosw
mov cx,33
mov si,160
mov di,318
l104:
mov word[es:di],ax
mov word[es:si],ax
add di,160
add si,160
loop l104

popa
ret

pro:
pusha
mov di,0
mov ax, 0xb800
mov es, ax ; point es to video base
xor di, di ; point di to top left column
mov ax, 0x3320 ; space char in normal attribute
mov cx, 2000 ; number of screen locations
cld ; auto increment mode
rep stosw ; clear the whole screen
mov ax,0x447c
mov cx,35
mov di,730
cld
rep stosw
mov di,3040
mov cx,35
cld
rep stosw
mov cx,80
mov di,0
cld
rep stosw
mov di,3680
mov cx,80
cld
rep stosw
mov cx,33
mov si,160
mov di,318
l102:
mov word[es:di],ax
mov word[es:si],ax
add di,160
add si,160
loop l102
mov cx,12
mov si,2010
mov di,1992
l101:
mov word[es:di],ax
mov word[es:si],ax
sub di,160
add si,160
loop l101

popa
ret
nov:
call novice
call initializing
call str1
jmp ll
p:
call pro
call initializing
call str1
jmp ll
start:
call clrscr
mov ah, 0x13 ; service 13 - print string
mov bl,7 ; normal attrib
mov dx, 0x0A03 ; row 10 column 3
mov cx, 21 ; length of string
push cs
pop es ; segment of string
mov bp, strr ; offset of string
int 0x10 ; call BIOS video service
mov ah, 0x13 ; service 13 - print string
mov bl, 7 ; normal attrib
mov dx, 0x0c03 ; row 10 column 3
mov cx, 73; length of string
push cs
pop es ; segment of string
mov bp, str2 ; offset of string
int 0x10 ; call BIOS video service
l100: mov ah, 0 ; service 0 – get keystroke
int 0x16 ; call BIOS keyboard service
cmp al, 0x31 ; 
je b
cmp al, 0x32 
je nov
cmp al, 0x33 
je p
jmp l100
b:
call borders
call initializing
call str1
ll:
xor ax,ax
mov es,ax
cli 				; disable interrupts
mov word [es:9h*4], kbisr 	; store offset at n*4
mov word[es:9h*4+2], cs 		; store segment at n*4+2
mov word[es:8h*4],timer
mov word[es:8h*4+2],cs
sti
ennd:
mov dx, start 
add dx, 15 
mov cl, 4
shr dx, cl 	
mov ax ,0x3100
int 21h