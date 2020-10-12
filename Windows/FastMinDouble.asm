; /*******************************************************************
; *
; *    Author: Kareem Omar
; *    kareem.h.omar@gmail.com
; *    https://github.com/komrad36
; *
; *    Last updated Oct 11, 2020
; *******************************************************************/

_TEXT$FastMinDouble SEGMENT ALIGN(64)

FastMinDouble PROC
 mov         eax,edx
 cmp         edx,32
 jae         CASE_LARGE
 vpcmpeqd    ymm0,ymm0,ymm0
db 03Eh
 vpcmpeqd    ymm1,ymm1,ymm1
 lea         r8,JUMP_TABLE
 movzx       edx,byte ptr [r8+rax]
 add         r8,rdx
 lea         rdx,[rcx+8*rax]
 and         eax,-4
 lea         rcx,[rcx+8*rax]
 jmp         r8
JUMP_TABLE:
db 1 DUP ( CASE_0 - JUMP_TABLE)
db 1 DUP ( CASE_1 - JUMP_TABLE)
db 1 DUP ( CASE_2 - JUMP_TABLE)
db 1 DUP ( CASE_3 - JUMP_TABLE)
db 1 DUP ( CASE_4 - JUMP_TABLE)
db 1 DUP ( CASE_5 - JUMP_TABLE)
db 1 DUP ( CASE_6 - JUMP_TABLE)
db 1 DUP ( CASE_7 - JUMP_TABLE)
db 4 DUP ( CASE_8 - JUMP_TABLE)
db 4 DUP (CASE_12 - JUMP_TABLE)
db 4 DUP (CASE_16 - JUMP_TABLE)
db 4 DUP (CASE_20 - JUMP_TABLE)
db 4 DUP (CASE_24 - JUMP_TABLE)
db 4 DUP (CASE_28 - JUMP_TABLE)
db 31 DUP (0CCh)
CASE_28:
 vmovupd     ymm0,ymmword ptr [rcx-224]
CASE_24:
 vmovupd     ymm1,ymmword ptr [rcx-192]
CASE_20:
 vminpd      ymm0,ymm0,ymmword ptr [rcx-160]
CASE_16:
 vminpd      ymm1,ymm1,ymmword ptr [rcx-128]
CASE_12:
 vminpd      ymm0,ymm0,ymmword ptr [rcx-96]
CASE_8:
 vminpd      ymm1,ymm1,ymmword ptr [rcx-64]
 vminpd      ymm0,ymm0,ymmword ptr [rcx-32]
 vminpd      ymm1,ymm1,ymmword ptr [rdx-32]
 vminpd      ymm0,ymm0,ymm1
 vextractf128 xmm1,ymm0,1
 vminpd      xmm0,xmm0,xmm1
 vpermilpd   xmm1,xmm0,1
 vminsd      xmm0,xmm0,xmm1
 ret
db 8 DUP (0CCh)
CASE_7:
 vmovsd      xmm0,qword ptr [rdx-56]
CASE_6:
 vminsd      xmm0,xmm0,qword ptr [rdx-48]
CASE_5:
 vminsd      xmm0,xmm0,qword ptr [rdx-40]
CASE_4:
 vminsd      xmm0,xmm0,qword ptr [rdx-32]
CASE_3:
 vminsd      xmm0,xmm0,qword ptr [rdx-24]
CASE_2:
 vminsd      xmm0,xmm0,qword ptr [rdx-16]
CASE_1:
 vminsd      xmm0,xmm0,qword ptr [rdx-8]
CASE_0:
 ret

db 1 DUP (0CCh)

CASE_LARGE:
 vmovupd     ymm0,ymmword ptr [rcx]
 vmovupd     ymm1,ymmword ptr [rcx+32]
 vmovupd     ymm2,ymmword ptr [rcx+64]
 vmovupd     ymm3,ymmword ptr [rcx+96]
 vmovupd     ymm4,ymmword ptr [rcx+128]
 vmovupd     ymm5,ymmword ptr [rcx+160]
 vmovapd     xmmword ptr [rsp+8],xmm6
 vmovupd     ymm6,ymmword ptr [rcx+192]
 vmovapd     xmmword ptr [rsp+24],xmm7
 vmovupd     ymm7,ymmword ptr [rcx+224]

 lea         rdx,[rcx+8*rax]
 add         rcx,512
 cmp         rcx,rdx
 jae         LOOP_END

LOOP_TOP:
 vminpd      ymm0,ymm0,ymmword ptr [rcx-256]
 vminpd      ymm1,ymm1,ymmword ptr [rcx-224]
 vminpd      ymm2,ymm2,ymmword ptr [rcx-192]
 vminpd      ymm3,ymm3,ymmword ptr [rcx-160]
 vminpd      ymm4,ymm4,ymmword ptr [rcx-128]
 vminpd      ymm5,ymm5,ymmword ptr [rcx-96]
 vminpd      ymm6,ymm6,ymmword ptr [rcx-64]
 vminpd      ymm7,ymm7,ymmword ptr [rcx-32]
 add         rcx,256
 cmp         rcx,rdx
 jb          LOOP_TOP

LOOP_END:
 vminpd      ymm0,ymm0,ymmword ptr [rdx-256]
 vminpd      ymm1,ymm1,ymmword ptr [rdx-224]
 vminpd      ymm2,ymm2,ymmword ptr [rdx-192]
 vminpd      ymm3,ymm3,ymmword ptr [rdx-160]
 vminpd      ymm4,ymm4,ymmword ptr [rdx-128]
 vminpd      ymm5,ymm5,ymmword ptr [rdx-96]
 vminpd      ymm6,ymm6,ymmword ptr [rdx-64]
 vminpd      ymm7,ymm7,ymmword ptr [rdx-32]

 vminpd      ymm2,ymm2,ymm6
 vmovapd     xmm6,xmmword ptr [rsp+8]
 vminpd      ymm3,ymm3,ymm7
 vmovapd     xmm7,xmmword ptr [rsp+24]
 vminpd      ymm0,ymm0,ymm4
 vminpd      ymm1,ymm1,ymm5

 vminpd      ymm0,ymm0,ymm2
 vminpd      ymm1,ymm1,ymm3

 vminpd      ymm0,ymm0,ymm1

 vextractf128 xmm1,ymm0,1
 vminpd      xmm0,xmm0,xmm1
 vpermilpd   xmm1,xmm0,1
 vminsd      xmm0,xmm0,xmm1
 ret
FastMinDouble ENDP

_TEXT$FastMinDouble ENDS

END
