.386
.model flat, stdcall
option casemap:none
includelib		msvcrt.lib
include			msvcrt.inc
printf			PROTO C :dword, :VARARG
scanf			PROTO C :dword, :VARARG
.data
input		    byte			"输入大数相乘的参数: ", 0
ans_a	        byte			"答案: %s", 0ah, 0
ans_b	        byte			"答案: -%s", 0ah, 0
buf_a			dword			150 dup(0)
buf_b			dword			150 dup(0)
buf_c			dword			301 dup(0)
flag			byte			0
len_a			dword           0
len_b			dword			0
len_c			dword			0
czbuf_a			dword			150 dup(0)
czbuf_b			dword			150 dup(0)
czbuf_c			dword			301 dup(0)
rad			    dword			10
sto			    db				'pause',0
pla		        sbyte			'%s',0
.code
reverse proc far C buf: ptr byte, rebuf: ptr byte, len: dword
mov				esi, buf
mov				ecx, len
a1:
movzx			eax, byte ptr [esi]
sub				eax, 48
push			eax
inc				esi
loop			a1
mov				esi, rebuf
mov				ecx, len
a2:
pop				eax
mov				dword ptr [esi], eax
add				esi, 4
loop			a2
ret
reverse			endp
make_output proc far C uses esi eax  ecx
mov				esi, 0
mov				ecx, len_c
a1:
mov				eax, dword ptr czbuf_c[4 * esi]
add				eax, 48
push			eax
inc				esi
loop			a1
mov				esi, 0
mov				ecx, len_c
a2:
pop				eax
mov				byte ptr buf_c[esi], al
inc				esi
loop			a2
ret
make_output     endp
getLen1 proc far C uses eax
mov				al, byte ptr buf_a[0]
cmp				eax, '-'					;负号的情况
jne				b1
xor				flag, 1
xor				eax, eax
invoke			crt_strlen, addr (buf_a+1)
mov				len_a, eax
invoke			reverse, addr (buf_a+1), addr czbuf_a, len_a
jmp				b2
b1:
xor				eax, eax
invoke			crt_strlen, addr buf_a
mov				len_a, eax
invoke			reverse, addr buf_a, addr czbuf_a, len_a
b2:
ret
getLen1			endp
getLen2 proc far C uses eax
mov				al, byte ptr buf_b[0]
cmp				eax, '-'					
jne				b1
xor				flag, 1
xor				eax, eax
invoke			crt_strlen, addr (buf_b+1)
mov				len_b, eax
invoke			reverse, addr (buf_b+1), addr czbuf_b, len_b
jmp				b2
b1:
xor				eax, eax
invoke			crt_strlen, addr buf_b
mov				len_b, eax
invoke			reverse, addr buf_b, addr czbuf_b, len_b
b2:
ret
getLen2			endp
multiply proc far C uses  ecx ebx eax  esi
mov				ebx, -1
c1:
inc				ebx
cmp				ebx, len_a
jge				c3
xor				ecx, ecx
c2:
xor				edx, edx
mov				eax, czbuf_a[4 * ebx]
mul				czbuf_b[4 * ecx]	
mov				esi, ecx
add				esi, ebx
add				czbuf_c[4 * esi], eax
inc				ecx
cmp				ecx, len_b
jge				c1				
jmp				c2
c3:
mov				ecx, len_a
add				ecx, len_b
inc				ecx
mov				esi, offset len_c
mov				[esi], ecx
xor				ebx, ebx
c4:
cmp				ebx, ecx
jge				c5
mov				eax, czbuf_c[4 * ebx]
xor				edx, edx
div				rad
add				czbuf_c[4 * ebx + 4], eax
mov				czbuf_c[4 * ebx], edx
inc				ebx
jmp				c4
c5:
mov				ecx, len_c
c6:
cmp				dword ptr czbuf_c[4 * ecx], 0
jne				c7
dec				ecx
jmp				c6
c7:
inc				ecx
mov				esi, offset len_c
mov				[esi], ecx
invoke			make_output
ret
multiply		endp
main			proc            
invoke			crt_printf, addr input
invoke			crt_scanf, addr pla, addr buf_a
invoke			crt_printf, addr input
invoke			crt_scanf, addr pla, addr buf_b
invoke			getLen1
invoke			getLen2
invoke			multiply
cmp				flag, 1
jne				d1
invoke			crt_printf, addr ans_b, addr buf_c
jmp				d2
d1:
invoke			crt_printf, addr ans_a, addr buf_c
d2:
invoke			crt_system, addr sto
ret
main			endp
end				main