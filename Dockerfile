FROM kalilinux/kali-rolling 

RUN apt-get update -y > /dev/null 2>&1 && apt-get upgrade -y > /dev/null 2>&1 && apt-get install locales -y \ 
     && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \ 
     && apt-get install ssh wget unzip openssh-server -y > /dev/null 2>&1 
ARG ngrokid
ARG Password
ENV Password=${Password}
ENV ngrokid=${ngrokid}
RUN wget -O ngrok.zip https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-stable-linux-amd64.zip > /dev/null 2>&1 \ 
     && unzip ngrok.zip 
RUN echo "./ngrok config add-authtoken ${ngrokid} &&" >>/kali.sh \ 
     && echo "./ngrok tcp --region=jp 22 &>/dev/null &" >>/kali.sh \ 
     && echo 'mkdir -p /run/sshd' >>/kali.sh \ 
     && echo '/usr/sbin/sshd -D' >>/kali.sh \ 
     && echo 'echo "By Radhin Development"' >> /kali.sh 
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config \ 
     && echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config \ 
     && echo root:${Password}|chpasswd 
RUN service ssh start 
RUN chmod 755 /kali.sh 
EXPOSE 22 80 8888 8080 443 5130 5131 5132 5133 5134 5135 3306 
CMD  /kali.sh
