.data

	unsec:		.word 0x5F5E100 	#1s
	mezzosec:	.word 0x4C4B40		#50ms
	
	cinquanta: 	.word 0x6DDAC0 		
	cinquanacinque:	.word 0x63DC77 		
	sessanta:	.word 0x5B88D0		


	I_O:	.half 0x0	#inizializzazione variabile a 16 bit
	
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
	lhu $s1, check1
	lhu $s2, check2
	lw $s3, cinquanta
	lw $s4, cinquanacinque	
	lw $s5, sessanta


Sensore1:
	lh $t0, I_O			#controlla riga 15 se macchina passata
	and $t1, $t0, $s1
	beq $t1, $s1, Sensore2
	j Sensore1

Sensore2:
	lh $t0, I_O			#controlla riga 14 se macchina passata
	and $t1, $t0, $s2
	beq $t1, $s2, Controllo
	addi $t2, $t2, 3		#contatore per le 3 istruzioni precedenti
	j Sensore2


Controllo:
	#controllo velocità confrontando il numero di istruzioni

	slt $t4, $t2, $s3
	beq $t4, $t7, Impulso
	j OO

Impulso:
	#ciclo 50 ms
	j Otturatore

Otturatore:
	#ciclo 1 sec con controllo riga 7
	j Sanzione
	
Sanzione:
	slt $t4, $t2, $s5
	beq $t4, $t7, II
	slt $t4, $t2, $s4
	beq $t4, $t7, IO
	slt $t4, $t2, $s3
	beq $t4, $t7, OI


OO:
	j FINE
II:

OI:

IO:







FINE:
	#riporre tutto a zero




