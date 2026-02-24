# Image de base Ubuntu 24.04
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Installation des paquets
RUN apt update && apt install -y \
    openssh-server \
    sudo \
    iproute2 \
    iputils-ping \
    net-tools \
    dnsutils \
    curl \
    wget \
    traceroute \
    telnet \
    lsof \
    tcpdump \
    htop \
    strace \
    vim \
    less \
    nano \
    gnupg \
    && rm -rf /var/lib/apt/lists/* && \
    apt-get clean

# Préparer le répertoire nécessaire à sshd
RUN mkdir /var/run/sshd

# Définir un mot de passe pour root (à ne jamais faire en production)
RUN echo "root:P@ssw0rd" | chpasswd

# Autoriser la connexion root par mot de passe
RUN sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Fix PAM (évite que SSH déconnecte l'utilisateur immédiatement)
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

RUN apt update

RUN apt install software-properties-common -y

RUN apt-add-repository --yes --update ppa:ansible/ansible

RUN apt install ansible -y

# Expose port SSH
EXPOSE 22

# Lancer SSH en avant-plan pour maintenir le conteneur actif
CMD ["/usr/sbin/sshd", "-D"]