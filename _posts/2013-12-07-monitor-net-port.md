当我们用netstat -an的时候，我们有时候可以看到类似的输出：

udp 0 0 0.0.0.0:32768 0.0.0.0:*

但是查找/etc/services又没有这个端口的相关说明，怎么办呢？这个是不是黑客程序？有没有办法查看究竟什么程序监听在这个端口？

使用lsof -i :32768就可以看到：

COMMAND PID USER FD TYPE DEVICE SIZE NODE NAME
            rpc.statd 603 root 4u IPv4 953 UDP *:32768
                        rpc.statd 603 root 6u IPv4 956 TCP *:32768 (LISTEN)

    原来是rpc的程序。

    使用lsof -i :port就能看见所指定端口运行的程序，同时还有当前连接。
