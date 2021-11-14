.386
.model flat, stdcall
option casemap:none

includelib user32.lib
includelib msvcrt.lib
includelib kernel32.lib

scanf PROTO C : ptr sbyte, :VARARG
printf PROTO C : ptr sbyte, :VARARG
.data
forIntNumber	db '%d',0
forEnter	db ' ',0
forString	db '%s',0
IntNumberHolder dd 0
n DD 0
sum DD 0
i DD 0
j DD 0
flag DD 0
_temp1 DD 0
_temp2 DD 0
_1sc  DB "Please input a number:\n",0ah,0
res DD 0
_2sc  DB "The number of prime numbers within n is:\n",0ah,0
.code
__init:
	call main
	ret
Mars_PrintInt:
	mov esi, [esp+4]
	pushad
	invoke printf, offset forIntNumber, esi
	invoke printf, offset forEnter
	popad
	ret
Mars_GetInt:
	pushad
	invoke scanf, offset forIntNumber, offset IntNumberHolder
	popad
	lea eax, IntNumberHolder
	mov eax, [eax]
	ret
Mars_PrintStr:
	mov esi, [esp+4]
	pushad
	invoke printf, offset forString, esi
	popad
	ret
prime:
MOV esi, [esp+4]
MOV n, esi
pushad
MOV EBP, ESP
MOV sum, 0
MOV flag, 1
MOV i, 2
_1LOP1:
MOV EAX, n
CMP i, EAX
JBE _1LOP2
JNBE _1LOP3
_1LOP4:
	INC i
	jmp _1LOP1
_1LOP2:
MOV flag, 1
MOV j, 2
_2LOP1:
MOV EAX, j
MUL j
MOV _temp1, EAX
MOV EAX, i
CMP _temp1, EAX
JBE _2LOP2
JNBE _2LOP3
_2LOP4:
	INC j
	jmp _2LOP1
_2LOP2:
MOV EAX, i
	XOR EDX, EDX
DIV j
MOV _temp2, EDX
CMP _temp2, 0
JE _1_true
JNE _1_false
_1_true:
MOV flag, 0
	JMP _2LOP3
	JMP _1_end
_1_false:
_1_end:
	jmp _2LOP4
_2LOP3:
CMP flag, 1
JE _2_true
JNE _2_false
_2_true:
	INC sum
PUSH i
CALL Mars_PrintInt
	SUB esp, 4
	JMP _2_end
_2_false:
_2_end:
	jmp _1LOP4
_1LOP3:
MOV ESP, EBP
popad
MOV EAX, sum
RET
main:
pushad
MOV EBP, ESP
MOV EAX, offset _1sc
PUSH EAX
CALL Mars_PrintStr
	SUB esp, 4
CALL Mars_GetInt
	SUB esp, 4
MOV n, EAX
PUSH n
CALL prime
MOV res, EAX
MOV EAX, offset _2sc
PUSH EAX
CALL Mars_PrintStr
	SUB esp, 4
PUSH res
CALL Mars_PrintInt
	SUB esp, 4
MOV ESP, EBP
popad
MOV EAX, 0
RET
end __init
