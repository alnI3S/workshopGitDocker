# image de base
FROM    ubuntu:22.04

# installer des packages d'Ubuntu
RUN apt update && apt install -qqy x11-apps \
    python3 python3-pip \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# install jupyter lab
RUN pip install jupyterlab

# ajout d'un utilisateur non-root
RUN useradd --shell /bin/bash -u 1001 -c "" -m user

# personnalisation avec LOCAL_USER_ID comme utilisateur non-root
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x  /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# commande par défaut
CMD ["/bin/bash"]