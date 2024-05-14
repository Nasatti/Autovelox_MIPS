.data

	unsec:		.word 0x5F5E100 	#1s
	mezzosec:	.word 0x4C4B40		#50ms
	
	cinquanta: 	.word 0x6DDAC0 		#50 km/h --> 13,89 m/s --> 0,072s --> 7199424 n cicli per andare a 50 km/h
	cinquanacinque	.word 0x63DC77 		#55 km/h --> 15,28 m/s --> 0,065s --> 6544503 n cicli per andare a 55 km/h
	sessanta	.word 0x5B88D0		#60 km/h --> 16,67 m/s --> 0,06s  --> 5998800 n cicli per andare a 60 km/h


	I_O	.half 0x0	#inizializzazione variabile a 16 bit
	
	#I_O
	#15--> primo sensore
	#14--> secondo sensore
	#7--> otturatore
	#1 e 0 --> risposta velocità

	check1	.half 0x8000	#controllo primo sensore linea 15
	check2	.half 0x4000	#controllo secondo sensore linea 14
	

.text

main:
	add $t2, $t2, $zero		#inizializzazione contatore

Sensore1:
	lh $t0, I_O			#controlla riga 15 se macchina passata
	and $t1, $t0, check1
	beq $t1, check1, Sensore2
	j Sensore1

Sensore2:
	lh $t0, I_O			#controlla riga 14 se macchina passata
	and $t1, $t0, check2
	beq $t1, check2, Controllo
	addi $t2, $t2, 3		#contatore per le 3 istruzioni precedenti
	j Sensore2


Controllo:
	#controllo velocità confrontando il numero di istruzioni

	slt $t4, $t2, cinqquanta
	beqi $t4, 1, Impulso
	j 00

Impulso:
	#ciclo 50 ms
	j Otturatore

Otturatore:
	#ciclo 1 sec con controllo riga 7
	j Sanzione
	
Sanzione:
	slt $t4, $t2, sessanta		
	beqi $t4, 1, 11
	slt $t4, $t2, cinquanacinque
	beqi $t4, 1, 10
	slt $t4, $t2, cinquanta
	beqi $t4, 1, 01


00:
	j FINE
11:

01:

10:







FINE:
	#riporre tutto a zero




