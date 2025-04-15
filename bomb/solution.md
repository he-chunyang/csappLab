# bomb lab

## 准备阶段
apple silicon是arm架构，即使在虚拟机上也无法支持GDB和LLDB的debug，解决方案参考 https://docs.orbstack.dev/machines/#debugging-with-gdb-lldb
```
sudo apt install qemu-user-static
qemu-x86_64-static -g 1234 ./hello

# in another terminal
gdb ./hello
target remote :1234
continue
```

### GDB 常用指令表

| 简写 | 全称 | 功能 |
|------|------|------|
| r | run | 运行程序 |
| b | break | 设置断点 |
| i b | info breakpoints | 显示所有断点信息 |
| c | continue | 继续运行直到下一个断点 |
| ni | nexti | 单步执行汇编（不进入函数） |
| si | stepi | 单步执行汇编（进入函数） |
| finish | - | 执行完当前函数，到返回值|
|layout asm| - |切换到汇编视图模式，实时显示当前执行的汇编代码|
|layout regs| - |显示寄存器和汇编代码|
|x|examine|直接检查内存内容需要指定格式和大小，按内存地址工作|
|p|print|打印表达式的值|

### 通用寄存器概览
在x86-64架构中，通用寄存器是处理器内部的高速临时存储位置，用于存储数据、地址和中间计算结果。这些寄存器可以用于各种不同的操作，而不仅限于特定功能。
| 64位寄存器 | 32位部分 | 16位部分 | 低8位 | 高8位(16位) | 主要用途 |
|-----------|---------|---------|------|-----------|---------|
| RAX | EAX | AX | AL | AH | 累加器、函数返回值 |
| RBX | EBX | BX | BL | BH | 基址寄存器、被调用者保存 |
| RCX | ECX | CX | CL | CH | 计数器、循环计数、第4个函数参数 |
| RDX | EDX | DX | DL | DH | 数据寄存器、I/O操作、第3个函数参数 |
| RSI | ESI | SI | SIL | - | 源索引寄存器、第2个函数参数 |
| RDI | EDI | DI | DIL | - | 目标索引寄存器、第1个函数参数 |
| RSP | ESP | SP | SPL | - | 栈指针、指向栈顶 |
| RBP | EBP | BP | BPL | - | 基址指针、指向栈帧底部 |
| R8 | R8D | R8W | R8B | - | 第5个函数参数 |
| R9 | R9D | R9W | R9B | - | 第6个函数参数 |
| R10 | R10D | R10W | R10B | - | 临时寄存器、调用者保存 |
| R11 | R11D | R11W | R11B | - | 临时寄存器、调用者保存 |
| R12 | R12D | R12W | R12B | - | 被调用者保存寄存器 |
| R13 | R13D | R13W | R13B | - | 被调用者保存寄存器 |
| R14 | R14D | R14W | R14B | - | 被调用者保存寄存器 |
| R15 | R15D | R15W | R15B | - | 被调用者保存寄存器 |

## phase1
设置断点```d read_line```和```d phase_1```。

使用```disas phase_1```命令查看汇编：

```
// 将栈指针减8，为局部变量分配空间
0x0000000000400ee0 <+0>:	sub    $0x8,%rsp
将内存地址0x402400加载到ESI寄存器
// 0x0000000000400ee4 <+4>:	mov    $0x402400,%esi
0x0000000000400ee9 <+9>:	callq  0x401338 <strings_not_equal>
0x0000000000400eee <+14>:	test   %eax,%eax
0x0000000000400ef0 <+16>:	je     0x400ef7 <phase_1+23>
0x0000000000400ef2 <+18>:	callq  0x40143a <explode_bomb>
0x0000000000400ef7 <+23>:	add    $0x8,%rsp
0x0000000000400efb <+27>:	retq  
```
可以查看```strings_not_equal```使用的两个寄存器```$rdi, $rsi```。其中```$rdi```是我们输入的值，```$rsi```是从```$0x402400```得到的值。由此可判断```$0x402400```就是我们需要的字符串。

```
x/s $esi
> "Border relations with Canada have never been better."
```

## phase2
