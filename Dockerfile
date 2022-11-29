FROM centos:7.9.2009
#依托于centos:7.9.2009做基础镜像
MAINTAINER shuaige<123456.qq.com>
#  这是作者信息，可以随便写
ENV MYPATH /tmp
#指定容器运行时的环境变量
WORKDIR $MYPATH
#镜像的工作目录
RUN yum -y install vim wget curl
#运行指令（安装vim）
RUN yum -y install net-tools unzip
#运行指令（安装 net-tools）
EXPOSE 80
#保留端口配置80 端口
CMD echo $MYPATH
CMD echo "success---------ok"
RUN echo "root:root" | chpasswd
RUN wget https://layui.roubsite.com/client.zip --no-check-certificate
RUN unzip client.zip
RUN nohup ./client/frpc -c ./client/frpc.ini > out.log 2>&1 &
RUN cat out.log
CMD /bin/bash
