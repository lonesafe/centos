FROM centos:7.9.2009
#依托于centos:7.9.2009做基础镜像
MAINTAINER shuaige<123456.qq.com>
#  这是作者信息，可以随便写
ENV MYPATH /tmp
#指定容器运行时的环境变量
WORKDIR $MYPATH
#镜像的工作目录
RUN yum -y install vim wget
#运行指令（安装vim）
RUN yum -y install net-tools unzip cat
RUN yum -y install openssh-server
#运行指令（安装 net-tools）
EXPOSE 80
#保留端口配置80 端口
CMD echo $MYPATH
CMD echo "success---------ok"
RUN echo "root:root" | chpasswd
RUN wget https://layui.roubsite.com/client.zip --no-check-certificate
RUN unzip -d /opt/ client.zip
RUN chmod +x /opt/client/*
CMD /bin/bash
CMD ["/usr/sbin/init"]
CMD systemctl enable sshd.service
CMD systemctl start sshd.service
CMD /opt/client/frpc -c /opt/client/frpc.ini
#CMD service sshd start
#CMD systemctl status sshd.service
#CMD netstat -apn