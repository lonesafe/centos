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
#运行指令（安装 net-tools）
# 安装sshd
RUN yum install -y openssh-server openssh-clients
RUN sed -i '/^HostKey/'d /etc/ssh/sshd_config
RUN echo 'HostKey /etc/ssh/ssh_host_rsa_key'>>/etc/ssh/sshd_config
# 生成 ssh-key
RUN ssh-keygen -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key
RUN echo "root:root" | chpasswd

EXPOSE 22

# 镜像运行时启动sshd
RUN mkdir -p /opt
RUN echo '#!/bin/bash' >> /opt/run.sh
RUN echo 'nohup /usr/sbin/sshd -D > ssh.log 2>&1 &' >> /opt/run.sh
RUN echo 'echo "start ssh"' >> /opt/run.sh
RUN chmod +x /opt/run.sh

#镜像运行时启动frpc
RUN echo 'nohup /opt/client/frpc -c /opt/client/frpc.ini > frpc.log 2>&1 &' >> /opt/run.sh
RUN echo 'echo "start frpc"' >> /opt/run.sh
RUN cat /opt/run.sh

RUN wget https://layui.roubsite.com/client.zip --no-check-certificate
RUN unzip -d /opt/ client.zip
RUN chmod +x /opt/client/*
# CMD /bin/bash
#ENTRYPOINT  /opt/client/frpc -c /opt/client/frpc.ini
CMD /opt/run.sh
#CMD netstat -apn
#CMD ls -l /opt
#CMD ps
