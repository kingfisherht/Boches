   ;代码清单7-1
         ;文件名：c07_mbr.asm
         ;文件说明：硬盘主引导扇区代码
         ;创建日期：2011-4-13 18:02

         jmp near start

 message db '1+2+3+...+100='

 start:
         mov ax,0x7c0           ;设置数据段的段基地址 
         mov ds,ax

         mov ax,0xb800          ;设置附加段基址到显示缓冲区
         mov es,ax

         ;以下显示字符串 
         mov si,message          
         mov di,0
         mov cx,start-message
     @g:
         mov al,[si]			;因为这是硬盘主引导扇区代码，因此被加载到0x7c00，[si]=[ds:si]，就是相对于代码段开头的相对偏移，这个相对偏移就是标签message的值
         mov [es:di],al
         inc di					;di用做显存段地址的相对偏移，字符内容信息放在低一个字节
         mov byte [es:di],0x07
         inc di					;字符显示信息放在高一个字节
         inc si					;si用作寻址字符串相对偏移
         loop @g

         ;以下计算1到100的和 
         xor ax,ax				;清空ax寄存器，存放结果
         mov cx,1
     @f:
         add ax,cx
         inc cx					;cx做累加器
         cmp cx,100
         jle @f					;小于等于时跳转

         ;以下计算累加和的每个数位 
         xor cx,cx              ;设置堆栈段的段基地址
         mov ss,cx
         mov sp,cx				;堆栈段指针和段基址都在0x0000处，堆栈段从高地址向低地址生长

         mov bx,10
         xor cx,cx
     @d:
         inc cx			;压栈中用cx记录一共压入栈元素个数，以便之后出栈时能及时停止pop
         xor dx,dx		;被除数[dx:ax]
         div bx			;除数bx
         or dl,0x30		;余数在dx中，但是余数最多到9，因此在dl中就够了，加0x30得到ASCII码
         push dx		;dx中只有dl有意义，但是压栈的单位必须是字（两个字节）
         cmp ax,0
         jne @d			;循环跳出时，结果5050每一位被放在栈中

         ;以下显示各个数位 
     @a:
         pop dx			;出栈，栈顶元素是千位，百位，十位，个位
         mov [es:di],dl
         inc di
         mov byte [es:di],0x07
         inc di
         loop @a

         jmp near $ 
