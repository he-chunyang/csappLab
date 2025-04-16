# ./gdbinit
# 设置默认文件输入，这样我们不必每次手动输入答案
set args key.txt

# 可以为 explode_bomb 函数设置断点，这样我们就可以在爆炸之前打断程序的执行
# 但是由于其会打印输出信息，所以后面有更具有针对性的设置，跳过信息发送函数
# 所以这里就不再设置断点了
# b explode_bomb

# 为各个 phase 函数设置断点，用以观察其执行过程
# 如果你做完了某个 phase，可以将其注释掉，这样就不会再进入该 phase 了
# b phase_1
b phase_2
b phase_3
b phase_4
b phase_5
b phase_6



