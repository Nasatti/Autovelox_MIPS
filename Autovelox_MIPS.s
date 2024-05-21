.data

	I_O:		.half 0x0		
	
	unsec:		.word 0x5F5E100 	#1s
	cinqms:		.word 0x04C4B40		#50ms
	
	cinquanta: 	.word 0x6DDAC0 		
	cinquanacinque:	.word 0x63DC77 		
	sessanta:	.word 0x5B88D0		

	check1:		.half 0x8000	#maschera primo sensore linea 15
	check2:		.half 0x4000	#maschera secondo sensore linea 14
	

.text

main:
	addi $t7, $zero,1
	lh $s1, check1
	lh $s2, check2
	lw $s3, cinquanta
	lw $s4, cinquanacinque	
	lw $s5, sessanta
	lw $s6, cinqms
	lw $s7, unsec


Sensore1:				#controlla se la macchina è passata al primo sensore (Linea 15=1)
	lh $t0, I_O			
	and $t1, $t0, $s1
	beq $t1, $s1, Sensore2
	j Sensore1

Sensore2:				#controlla se la macchina è passata al secondo sensore (Linea 14=1)
	lh $t0, I_O			
	and $t1, $t0, $s2
	addi $t2, $t2, 4		
	beq $t1, $s2, Sanzione
	j Sensore2
	
Sanzione:				#controlla la velocità tramite $t2 (count) e verifica la necessità di una sanzione
	slt $t4, $t2, $s5
	beq $t4, $t7, II	#>60
	slt $t4, $t2, $s4
	beq $t4, $t7, IO	#>55
	slt $t4, $t2, $s3
	beq $t4, $t7, OI	#>50
	j OO

OO:					#imposta le linee 0 e 1 in base alla velocità
	j reset
II:				
	ori $t0, $t0, 0x3		
	j RitornaV
OI:
	ori $t0, $t0, 0x1
	j RitornaV
IO:
	ori $t0, $t0, 0x2
	j RitornaV


RitornaV:				#Salva in I_O le modifiche in base alla velocità
	sh $t0, I_O
	j Attesa

Attesa:					
	addi $t5,$t5,2			
	bne $t5, $s7, Attesa		#Attende 1 secondo
	add $t5,$zero,$zero			
	ori $t0, $t0, 0x80 		#Apre otturatore (Linea 7=1)
	sh $t0, I_O
	j Impulso
	


Impulso:
	addi $t5,$t5,3			#Attende 50ms		
	bne $t5, $s6, Impulso
	andi $t0, $t0, 0xFF7F		#Chiude otturatore (Linea 7=0)
	sh $t0, I_O
	j reset




reset:					#reset variabili e riparte
	add $t4, $zero, $zero
	add $t5, $zero,$zero
	add $t2, $zero, $zero
	sh $t4, I_O
	j Sensore1