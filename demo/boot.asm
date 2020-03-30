org    07c00h                      ; 告诉编译器程序加载到7c00处
    mov    ax, cs
    mov    ds, ax
    mov    es, ax
    call    DispStr                ; 调用显示字符串例程
    jmp    $                       ; 无限循环 $代表当前地址
DispStr:
    mov    ax, BootMessage
    mov    bp, ax                  ; ES:BP = 串地址
    mov    cx, msgLen              ; CX = 串长度
    mov    ax, 01301h              ; AH = 13,  AL = 01h
    mov    bx, 000ch               ; 页号为0(BH = 0) 黑底红字(BL = 0Ch,高亮)
    mov    dl, 50                  ; 将DL中的ASCII码显示到屏幕,将'\0'送到DL中，并显示
    int    10h                     ; 10h 号中断
    ret                            ; 返回到调用处
BootMessage:        db    "Hello, zhang xue peng !"
msgLen: equ $ - BootMessage


