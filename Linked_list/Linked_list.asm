    #Athanasios Kazakis 3729
    #Create a linked list 
    #Inserting  unlimited elements
    #stdin 0 
    #After enetering 0  give a number that you want to print the  elements in linked list bigger than the 
    #stdin number 
    
    .data 
    .align 2 
    #Strings gia omorfo typwma
str_prompt: .asciz "Enter Int to Print > from him\n"
str_sp:.asciz" "
str_inv: .asciz "Negative number or 0 given!"
str_nonext: .asciz "End of list reached!"
str_nl:.asciz"\n"
str_n:.asciz"Enter Integers.\n"
#ksekinaei to .text ksekinaei o kwdikas. Dhlwsh synarthsewn.
         .text
        .globl main
      
        .globl read_loop
        .globl read_int
        .globl node_alloc
        .globl Exit_Reading
        .globl search_loop
        .globl print_node
        .globl check_next
        .globl search_list
	.globl Exit_Reading2
	.globl end
	.globl return

#H main kalei tin synarthsh node alloc kai  h node alloc 
# kanei allocate  bytes gia th lysta 
#ston kataxwrhth x20 vazoyme afto pou daivasame(apo to x10)
#kanoume store to ->data sto  x20 kai epita 
#proxorame ton pointer 4 bytes parkatw wste na kanoume store to ->next
#kai stous saved kataxwrites s0 kai s1 vazoume ta dedomena tou x20
main: 
        addi    x17, x0, 4      # environment call code for print_string
        la      x10, str_n      # pseudo-instruction: address of string
        ecall                   # print the string from str_nÏ
        
        jal node_alloc #allocate 8 bytes
        addi x20,x10,0 
        sw x0, 0(x20) #data=0
        sw x0, 4(x20) #nextPtr=0
        add s0, x20, x0 #load address of  data in s0
        add s1, x20, x0  #load adrress of data in s1    
        
#h read loop diavazei ints apo to stdin gia na ta vali sth lista      
#an einai 0 tote pigene sto Exit reading pou  ekei ksekinaei h diadikasia
#1) na diavasei to int  ( pou uaprxi sti lista) kai na tipwsei ta megalitera tou
# an einai aritnikos omia termiatise to programa. 
#meta pou tha teleiosei me ta ton elegxo ,
#1)valle ton x21 se temp metavlhth (min xathei)
#)tsekarw an oi kataxwrites gia to (addr) s0,s1 einai isoi tote pigene stin initComp
#h initComp kanei:
#1)arxika kanei malloc  gia tis epomenes thesis pou tha diavasoume
#2)apothikevei ston x20 afto pou diavasame kai ton kanei store ston temp (t0) to addr tou kai epita to value tou 
#3)kai pigene sto next node (kane ->next) kai ksana pigene stin j read_loop gia na sinexisei to diavasma
#4 meta h read_loop sinexizei kai  kalei tin alloc (an den kalestei i InitComp) kai
#5) ektelesei tin idia diadikasia me tin initComp
read_loop:  
        jal read_int
        beq x21, x0, Exit_Reading     #exit if number = 0
        slti t0, x21, 0   # set less than i .  if int<0 true
        #an einai arntitikos aftos pou diavasame tote pigene sto exit reading
        bne t0, x0, Exit_Reading  
        addi t0, x21,0   #t0=x21+0;
        beq s0,s1,initComp    #if s0=ss1 
        jal node_alloc #call malloc 
        addi x20,x10,0 
        sw t0, 0(x20)  #place x in the data of the new mode
        sw x0, 4(x20)    #set nextptr =0
        addi t0, x20, 0      #point to the last node
        sw t0,4(s1)
        addi s1,x20,0
        j read_loop
Exit_Reading:
	addi x17,x0,4 
	la x10,str_prompt
	ecall
	jal read_int
	addi  s1,x21,0 
	slti t0,s1,0 #if int<0
	bne t0,x0,exit #exit if <0
	lw s2,4(s0) #load the node
#H synarthsh afth einai gia na kalei tin search_list   gia to tywpa sto stdout
 Exit_Reading2:
		add a0,x0,s2 #a0=s2=s0
		add a1,x0,s1 #a1=s1=x
		jal search_list #call search list
		j Exit_Reading
initComp: 
	jal node_alloc #malloc 
	addi x20,x10,0
	sw t0,(x20) #store tha value that is was readen
	addi t0,x20,0 #load the adress of the new node
	sw t0,4(s0) #point to the next node
	addi s1,x20,0 #load address of new node on s1
	j read_loop  
#stamatei to programma 
exit:
	addi x17,x0,10 #stops the programm
	ecall                
#sinarthsh gia elehxo 
search_loop:
        lw a0, 0(s2)          #s2 address    
        add a1, s1, x0          #integer with whom we compare with  
        jal search_list
        
#go to next. s2=s2->next;
check_next:
        lw t2, 4(s2)
        add s2, x0, t2        #s2  = s2->next
        bne s2, x0, search_loop
   #ftasame sto telos tis listas  NULL 
no_next:
        addi x17, x0, 4
        la x10, str_nonext
        ecall
        addi x17, x0, 4
        la  x10, str_nl
        ecall

   #kanei allocate bytes 

node_alloc:
        addi x17, x0, 9
        addi x10, x0, 8 #allocate 8 bytes of memory
        ecall                 #system call for set break
        jr ra,0     
#diavase to int 
read_int:
        addi x17, x0, 5          #system call for read_int
        ecall
        add x21, x10, x0         #save what we read in $v0
        jr ra,0           
#synarthseis  gia to tipwma
print_node:
        lw t1,0(a0) #load value of the node of the list
        slt t0,a1,t1 #compare the readen value
        bne t0,x0,end
        jr ra,0
       #synarthsh gia typwma
end:
	addi x17,x0,1 #print the loaded value from the list
	add a0,x0,t1
	ecall
	la a0,str_sp
	addi x17,x0,4
	ecall 
	jr ra,0
search_list:
#proxoraw ton stack pointer 4  thesis.
#vazw (push) ton a0 sto [0] to s1 sto [2] klp
#kai meta tous kanw free.
loop_search:
        addi sp, sp, -16
        sw a0, 0(sp)
        sw s1, 4(sp)
        sw ra, 8(sp)
        beq a0,x0,return
        slti t0,a0,0
        bne t0,x0,return
        jal print_node
        lw a0 0(sp)
        lw a1,4(sp)
        lw ra,8(sp)
        addi sp,sp,16
        lw a0,4(a0)
        j loop_search
        jr ra ,0
return:
	jr ra,0     
 
