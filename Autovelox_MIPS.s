.data

	I_O:	.half 0x0		#inizializzazione variabile a 16 bit
	
	unsec:		.word 0x5F5E100 	#1s
	cinqms:		.word 0x04C4B40		#50ms
	
	cinquanta: 	.word 0x6DDAC0 		
	cinquanacinque:	.word 0x63DC77 		
	sessanta:	.word 0x5B88D0		


	
	#I_O
	#15--> primo sensore
	#14--> secondo sensore
	#7--> otturatore
	#1 e 0 --> risposta velocità

	check1:	.half 0x8000	#controllo primo sensore linea 15
	check2:	.half 0x4000	#controllo secondo sensore linea 14
	

.text

main:
	add $t2, $t2, $zero		#inizializzazione contatore
	addi $t7, $zero,1
	add $t5, $zero,$zero		#contatore 50ms
	lh $s1, check1
	lh $s2, check2
	lw $s3, cinquanta
	lw $s4, cinquanacinque	
	lw $s5, sessanta
	lw $s6, cinqms
	lw $s7, unsec


Sensore1:
	lh $t0, I_O			#controlla riga 15 se macchina passata
	and $t1, $t0, $s1
	beq $t1, $s1, Sensore2
	j Sensore1

Sensore2:
	lh $t0, I_O			#controlla riga 14 se macchina passata
	and $t1, $t0, $s2
	addi $t2, $t2, 4		#contatore per le 4 istruzioni precedenti
	beq $t1, $s2, Sanzione
	j Sensore2
	
Sanzione:
	slt $t4, $t2, $s5
	beq $t4, $t7, II	#>60
	slt $t4, $t2, $s4
	beq $t4, $t7, IO	#>55
	slt $t4, $t2, $s3
	beq $t4, $t7, OI	#>50
	j OO

OO:
	j reset
II:				#salviamo la velocita
	ori $t0, $t0, 0x3		
	j RitornaV
OI:
	ori $t0, $t0, 0x1
	j RitornaV
IO:
	ori $t0, $t0, 0x2
	j RitornaV


RitornaV:			#Ritorniamo la velosita(bit 1 e 0)
	sh $t0, I_O
	j Attesa

Attesa:
	addi $t5,$t5,2			#ciclo 1 sec apri
	bne $t5, $s7, Attesa
	add $t5,$zero,$zero
				
	ori $t0, $t0, 0x80 		#mette a 1 riga 7
	sh $t0, I_O
	j Impulso
	


Impulso:
	addi $t5,$t5,3			#ciclo 50 ms impulso
	bne $t5, $s6, Impulso
	
	andi $t0, $t0, 0xFF7F		#riporre 0 linea 7
	sh $t0, I_O
	j reset




reset:					#ripatre il ciclo
	add $t4, $zero, $zero
	sh $t4, I_O
	j main


#velocità quando mandarla? prima di scattare la foto
#andi tra registro e numero? --> and come farla? or
#fotocamera mettiamo noi con set value o da codice automaticamente
#flow chart --> draw.io