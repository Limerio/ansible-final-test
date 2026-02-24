# Image de base Rocky Linux 9
FROM rockylinux:9

# Installation des paquets nécessaires
RUN dnf update -y && dnf install -y \
    openssh-server \
    sudo \
    iproute \
    iputils \
    net-tools \
    wget \
    traceroute \
    telnet \
    lsof \
    vim \
    nano \
    gnupg2 \
    && dnf clean all && \
    rm -rf /var/cache/dnf

# Préparer le répertoire nécessaire à sshd
RUN mkdir /var/run/sshd

# Définir un mot de passe pour root (à ne jamais faire en production)
RUN echo "root:P@ssw0rd" | chpasswd

# Autoriser la connexion root par mot de passe
RUN sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Fix PAM (évite que SSH déconnecte l'utilisateur immédiatement)
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

# Exposer le port SSH
EXPOSE 22

# Lancer SSH en avant-plan pour maintenir le conteneur actif
#CMD ["/usr/sbin/sshd", "-D"]
CMD ["/bin/bash", "-c", "ssh-keygen -A && /usr/sbin/sshd -D"]