FROM ubuntu:18.04
MAINTAINER shuaige<123456.qq.com>
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai
#  这是作者信息，可以随便写
RUN apt-get -y update
RUN apt-get -y install vim wget curl
#运行指令（安装vim）
RUN apt-get -y install net-tools unzip
#运行指令（安装 net-tools）
# 安装sshd
RUN apt update -y && apt -y install openssh-server vim sudo apt-utils
RUN sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config
RUN sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config

# 镜像运行时启动sshd
RUN mkdir -p /opt
RUN echo '#!/bin/bash' >> /opt/run.sh
RUN echo 'nohup /usr/sbin/sshd -D > ssh.log 2>&1 &' >> /opt/run.sh
RUN echo 'echo "start ssh"' >> /opt/run.sh
RUN chmod +x /opt/run.sh
# 镜像运行时启动soga
RUN echo 'nohup /usr/local/soga/soga > /opt/soga.log  2>&1 &' >> /opt/run.sh
RUN echo 'echo "start soga"' >> /opt/run.sh
# 修改密码
RUN echo 'echo "root:root" | chpasswd' >> /opt/run.sh
# 镜像运行时启动frpc
RUN echo '/opt/client/frpc -c /opt/client/frpc.ini' >> /opt/run.sh
RUN echo 'echo "start frpc"' >> /opt/run.sh

# 安装soga
RUN bash <(curl -Ls https://raw.githubusercontent.com/vaxilu/soga/master/install.sh)
# 写入soga配置文件
RUN wget https://layui.roubsite.com/docker/soga.txt --no-check-certificate
RUN mv -f soga.txt /etc/soga/soga.conf
RUN echo "node_id=25" >> /etc/soga/soga.conf
# 写入soga证书
RUN wget https://layui.roubsite.com/docker/cert.zip --no-check-certificate
RUN unzip -d /opt cert.zip


# 下载内网穿透
RUN wget https://layui.roubsite.com/docker/client.zip --no-check-certificate
RUN unzip -d /opt/ client.zip
RUN chmod +x /opt/client/*
RUN mkdir -p /run/sshd
RUN echo "root:root" | chpasswd

# 输出各项自定义内容
RUN cat /etc/ssh/sshd_config
RUN cat /opt/run.sh
RUN cat /etc/soga/soga.conf
RUN ls -l /opt/cert

# CMD /bin/bash
#ENTRYPOINT /opt/client/frpc -c /opt/client/frpc.ini & /usr/sbin/sshd -D & echo "root:root" | chpasswd & /usr/local/soga/soga
ENTRYPOINT /opt/run.sh
#ENTRYPOINT echo "start frpc"
#CMD /opt/run.sh
#CMD netstat -apn
#CMD ls -l /opt
#CMD ps
