　　一、安装ssh
　　ssh软件由两部分组成：ssh服务端和ssh客户端。
　　ssh的配置文件在/etc/ssh/目录下，其中服务端的配置文件是sshd_config，客户端的配置文件是ssh_config.
　　安装ssh，在这里，只讲述通过yum安装的方法（前提是你的yum源配置正确，并且能使用）：
　　# yum install openssh-* -y
　　//yum会自动安装所有openssh相关的软件包
　　二、配置ssh服务器
　　根据ssh的两种验证方式，配置两种不能安全级别的登录方式。
　　·通过口令验证方式登录
　　1.用vim编辑器打开sshd_config配置文件
　　# vim /etc/ssh/sshd_config
　　2.对配置文件进行如下修改（根据自身实际情况可有所调整）：
　　Port 22  //默认使用22端口，也可以自行修改为其他端口，但登录时要打上端口号
　　#ListenAddress   //指定提供ssh服务的IP，这里我注释掉。
　　PermitRootLogin   //禁止以root远程登录
　　PasswordAuthentication  yes  //启用口令验证方式
　　PermitEmptyPassword   //禁止使用空密码登录
　　LoginGraceTime  1m   //重复验证时间为1分钟
　　MaxAuthTimes   3    //最大重试验证次数
　　保存修改好的配置，退出。
　　3.重启sshd服务
　　# service sshd restart
　　·通过密钥对验证方式登录
　　1.在客户端生成密钥对
　　注：生成密钥对前，需切换相应用户身份。例如：当user1需要登录到服务端时，user1必须在客户端生成自己的密钥文件。其他用户也一样。
　　# su - user1
　　# ssh-keygen -t rsa    //生成密钥文件
　　Generating public/private rsa key pair.
　　Enter file in which to save the key （/root/.ssh/id_rsa）:   //按回车
　　Enter passphrase （empty for no passphrase）:   //设置保护私钥文件的密码，即密钥登录时的密码
　　Enter same passphrase again:  //再次输入保护私钥文件的密码
　　Your identification has been saved in /root/.ssh/id_rsa.
　　Your public key has been saved in /root/.ssh/id_rsa.pub.
　　The key fingerprint is:
　　33:ee:01:7d:c3:74:83:13:ef:67:ee:d7:60:2d:e1:16 root@localhost
　　# ll -a .ssh/
　　总计 24
　　drwxrwxrwx 2 root root 4096 10-08 19:29 .
　　drwxr-x--- 21 root root 4096 10-08 19:25
　　-rw------- 1 root root 1743 10-08 19:29 id_rsa     //创建的私钥
　　-rw-r--r-- 1 root root 396 10-08 19:29 id_rsa.pub  //创建的公钥
　　-rw-r--r-- 1 root root 790 2015-11-04 known_hosts
　　2.上传公钥文件到服务器或者用U盘拷贝到服务器里
　　# scp .ssh/id_rsa.pub user1@192.168.1.100:/home/user1/
　　3.在服务器端，将公钥文件添加到相应用户的密钥库里
　　# mkdir -p /home/user1/.ssh/       //注意，这里创建的。ssh目录权限必需是除自己外，对其他用户只读，也就是权限位设置为644，所属者与所属者组都是其用户
　　# mv /home/user1/id_rsa.pub /home/user1/,ssh/authorized_keys   //由于生成的公钥名称与指定的公钥名称不符，因此需要将生成的文件名换成authorized_keys即可。
　　4.修改sshd_config配置文件：
　　# vim /etc/ssh/sshd_config
　　PasswordAuthentication  no  //禁用口令验证方式，不能把原有的PasswordAuthentication  yes注释掉，注释后，就算没有公钥也能通过口令登录，这样不安全，而且失去了密钥验证的意义。
　　RSAAuthentication yes   //启用RSA验证
　　PubkeyAuthentication yes  //启用公钥验证
　　AuthorizedKeysFile     .ssh/authorized_keys   //启用公钥文件位置，后面的路径是设置公钥存放文件的位置
　　保存修改好的配置，退出。
　　5.重启sshd服务
　　# service sshd restart
