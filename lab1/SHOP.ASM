.386

STACK SEGMENT USE16 STACK
        DB 200 DUP(0)
STACK ENDS 

DATA SEGMENT USE16
	BNAME DB 'WL DING',0,0,0  ;�ϰ������������ҵ�����ƴ��������10���ֽڣ�����������д��
	BPASS DB '111111' ;����
	N EQU 30 ;��Ʒ����
	GA1 DB 'PEN',  7 DUP(0), 10 ;��Ʒ���Ƽ��ۿ�
      	        DW 35, 56, 70, 25, ? ;�Ƽ��Ȼ�δ����
	GA2 DB 'BOOK', 6 DUP(0), 9 ;��Ʒ���Ƽ��ۿ�
         	        DW 12, 30, 25, 5, ? ;�Ƽ��Ȼ�δ����
        GA3 DB 'TEST1',5 DUP(0), 9
                DW 500,30,25,5,? ;���ñȽϴ�Ľ����������������
        GA4 DB 'TEST2',5 DUP(0), 10
                 DW 0,30,25,0,? ;�����ۺ�������������Ϊ0�����ܷ��������
	GAN DB N-4 DUP('Temp-Value' ,8)
	         DW N-4 DUP(12,30,25,5,?) ;���˼����Ѿ����嶨���˵���Ʒ��Ϣ���⣬������Ʒ��Ϣ��ʱ�ٶ�Ϊһ����

	AUTH DB 0
	TEMP1 DW ?
	IN_NAME DB 12
       	   DB ?
	        DB 12 DUP(0)
	IN_PWD DB 10
            DB ?
            DB 10 DUP(0)
	IN_ITEM DB 12
        	   DB ?
      	   DB 12 DUP(0)
	PUTNAME DB 'PLEASE INPUT THE NAME(INPUT ENTER TO LOOKUP, INPUT Q TO QUIT)$'
	NOTITEM DB 'DO NOT FIND THE ITEM$'
	PUTPASSWORD DB 'PLEASE INPUT THE PASSWORD$'
	ITEMNAME DB 'PLEASE INPUT THE ITEM NAME(INPUT ENTER TO INPUT NAME)$'
	LOGFAIL DB 'YOUR USER NAME OR PASSWORD IS WRONG!$'
	LOGINREMIND DB 'IDENTIFICATION GOT!$'
	DATA ENDS

CODE SEGMENT USE16
	ASSUME CS:CODE, DS:DATA
START: 
	MOV AX,DATA
	MOV DS,AX ;�������ݶμĴ�����ֵ

INNAME:
	MOV AUTH,0
	LEA DX,PUTNAME ;��ʾ�û���������
	MOV AH,9H
	INT 21H
	MOV DL, 0AH
	MOV AH,2H
	INT 21H

	LEA DX,IN_NAME 
	MOV AH,10
	INT 21H
	MOV DL,0AH
	MOV AH,2H
	INT 21H
	LEA BX,OFFSET IN_NAME 

	CMP BYTE PTR [BX+2],0DH ;����ǻس�����ֱ�Ӳ�ѯ
	JE LOOKUP
	CMP BYTE PTR [BX+2],'Q' ;�����q���˳�
	JE EXIT

	MOV DI, OFFSET IN_NAME ;ָ������ĵ�ַ
	ADD DI,2
	MOV SI,OFFSET BNAME ;ָ��ԭ��ƥ�����ֵĵ�ַ
	SUB SI,1
	SUB DI,1
	MOV CX,0

LOPA:
	ADD DI,1
	ADD SI,1
	ADD CX,1
	CMP CX,8H
	JE PASSWORD 
	MOV BL,BYTE PTR [SI] ;��BL�д�����ʵ������
	CMP BL,BYTE PTR [DI] ;������ֵ������ʵ�������Ƚ�
	JE LOPA ;���Ϊ�棬����ִ����һ���Ƚ�
	JNE INPUTFAIL ;�粻Ϊ�棬����ʾʧ��

	PASSWORD:
	LEA DX,PUTPASSWORD ;��ʾ�û���������
	MOV AH,9H
	INT 21H
	MOV DL,0AH
	MOV AH,2H
	INT 21H

	LEA DX,OFFSET IN_PWD
	MOV AH,10
	INT 21H
	MOV DL,0AH
	MOV AH,2H
	INT 21
	LEA BX,OFFSET IN_PWD

	MOV DI,OFFSET IN_PWD ;ָ������ĵ�ַ
	ADD DI,2
	MOV SI,OFFSET BPASS ;ָ��ԭ��ƥ������ĵ�ַ
	SUB SI,1
	SUB DI,1
	MOV CX,0

LOPB:
	ADD DI,1
	ADD SI,1
	ADD CX,1
	CMP CX,7H 
	JE SUCCESSFUL ;�������ƥ��ɹ���������ɹ���Ϣ
	MOV BL, BYTE PTR [SI] ;BL�д�����ʵ����
	CMP BL,BYTE PTR [DI] ;�����������������Ƚ�
	JE LOPB ;��Ϊ��Ƚ���һλ
	JNE INPUTFAIL;����Ϊ������ʾʧ��

INPUTFAIL:
	MOV AUTH,0
	MOV DL,0AH
	MOV AH,2H
	INT 21H
	LEA DX, LOGFAIL
	MOV AH,9
	INT 21H
	MOV DL,0AH
	MOV AH,2H
	INT 21H
	JMP INNAME

SUCCESSFUL:
	MOV AUTH,1
	MOV DL,0AH
	MOV AH,2H
	INT 21H
	LEA DX,LOGINREMIND ;���ɹ�������ɹ�����ʾ��Ϣ
	MOV AH,9
	INT 21H
	MOV DL,0AH
	MOV AH,2H
	INT 21H
	JMP LOOKUP

LOOKUP:
	MOV DX,OFFSET ITEMNAME ;��ʾ����Ҫ���ҵĻ���
	MOV AH,9H
	INT 21H
	MOV DL,0AH
	MOV AH,2H
	INT 21H
	LEA DX,IN_ITEM ;�û�����Ҫ���ҵĻ��� 
	MOV AH,10
	INT 21H
	MOV BL,IN_ITEM+1
	MOV BH,0
	MOV BYTE PTR IN_ITEM+2[BX],'$' ;�����봮β������'$'
	MOV DL,0AH
	MOV AH,2H
	INT 21H

	MOV SI,OFFSET IN_ITEM
	CMP BYTE PTR [SI+2],0DH ;�ж��Ƿ�Ϊ�س���������ص������û���
	JE INNAME
        	MOV CX,N ;�趨ѭ��������
	MOV DX,OFFSET GA1


NEXT:
	MOV DI,OFFSET IN_ITEM
	MOV BL,BYTE PTR [DI+1]
	ADD BX,1
	ADD DI,2
	MOV SI,DX
	SUB SI,1
	SUB DI,1
	
LOPC:
	ADD DI,1
	ADD SI,1
	SUB BL,1
	CMP BL,0 
	JE FINDSUC
	MOV AL,BYTE PTR [SI]
	CMP AL,BYTE PTR [DI] ;����жϻ��������Ƿ����
	JE LOPC
	DEC CX
	ADD DX,21
	CMP CX,0
	JNE NEXT ;������û��ѭ���꣬�ж���һ������
	JE FINDFAIL ;��ѭ�����˻�û���ҵ��������ʧ��

FINDFAIL:
	LEA DX,NOTITEM ;���û���ҵ������û���ҵ��Ĵ�����Ϣ
	MOV AH,9H
	INT 21H
	MOV DL,0AH
	MOV AH,2H
	INT 21H
	JMP LOOKUP ;�ص�LOOKUP��������Ѱ��

FINDSUC:
	CMP AUTH,1 ;�жϵ�¼״̬���������Ѿ���½����ʾ����Ʒ���ƣ�������������Ƽ���
	JE PRINT
	MOV SI,DX
	MOV AL,[SI+10] ;�ۿ� 
        	MOV AH,0
        	MOV BX,[SI+13]  ;���ۼ�
        	MUL BX ;���ۼ۳����ۿ�
        	MOV BX,10
        	MOV DX,0
        	DIV BX ;���ۼ۳����ۿ۳���10��ʵ���ۼ�
        	MOV CX,AX
        	MOV AX,[SI]+11 ;������
        	MOV BX,128
        	MUL BX ;�����۳���128
        	MOV DX,0
        	DIV CX ;�����۳���128�������ۼ�
        	MOV TEMP1,AX
        	MOV AX,[SI]+17 ;��������
        	MOV BX,64 
        	MUL BX ;������������64
        	MOV BX,[SI]+15  ;��������
        	MOV DX,0
        	DIV BX ;������������64���Խ�������
	ADD AX,TEMP1 ;�������Ƽ�����ӣ�����AX
	CMP AX,100
	JGE LEVELA ;����100���A
	CMP AX,50
	JGE LEVELB ;����50���B
	CMP AX,10
	JGE LEVELC ;����10���C
	JMP LEVELF ;�������F

LEVELA:
	MOV DL,41H
	MOV AH,2
	INT 21H
	MOV DL,0AH
	MOV AH,2
	INT 21H
	JMP INNAME

LEVELB:
	MOV DL,42H
	MOV AH,2
	INT 21H
	MOV DL,0AH
	MOV AH,2
	INT 21H
	JMP INNAME	

LEVELC:
	MOV DL,43H
	MOV AH,2
	INT 21H
	MOV DL,0AH
	MOV AH,2
	INT 21H
	JMP INNAME

LEVELF:
	MOV DL,46H
	MOV AH,2
	INT 21H
	MOV DL,0AH
	MOV AH,2
	INT 21H
	JMP INNAME

PRINT:
	LEA DX,IN_ITEM+2
	MOV AH,9
	INT 21H
	MOV DL,0AH
	MOV AH,2
	INT 21H
	JMP INNAME

EXIT:
	MOV AH,4CH
	INT 21H

CODE ENDS

	END START 