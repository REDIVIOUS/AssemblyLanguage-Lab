.386
CODE SEGMENT USE16
    ASSUME CS:CODE
START:
    MOV AX,0
    MOV DS,AX
    MOV AH,35H
    MOV AL,1H
    INT 21H
    MOV AL,13H
    INT 21H
CODE ENDS
    END START
