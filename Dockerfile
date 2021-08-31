FROM ubuntu:focal
LABEL org.opencontainers.image.source="https://github.com/MultiVersion/bedrock" org.opencontainers.image.source="https://multiversion.dviih.technology/" org.opencontainers.image.version="LTS" org.opencontainers.image.revision="2108" org.opencontainers.image.authors="Dviih" org.opencontainers.image.licenses="unlicense.org"

ADD ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN \
  apt update && \
  apt install -y bash wget unzip && \
  cd /opt && \
  wget https://jenkins.pmmp.io/job/PHP-7.4-Aggregate/lastSuccessfulBuild/artifact/PHP-7.4-Linux-x86_64.tar.gz -O php.tar.gz && \
  tar -xzvf php.tar.gz && \
  rm php.tar.gz && \
  EXTENSION_DIR=$(find "/opt/bin" -name *debug-zts*) && \
  grep -q '^extension_dir' /opt/bin/php7/bin/php.ini && sed -i'bak' "s{^extension_dir=.*{extension_dir=\"$EXTENSION_DIR\"{" /opt/bin/php7/bin/php.ini || echo "extension_dir=\"$EXTENSION_DIR\"" >> /opt/bin/php7/bin/php.ini && \
  adduser --disabled-password --home /home/container container

USER container
ENV  USER=container HOME=/home/container
WORKDIR /home/container

CMD ["/bin/bash","/entrypoint.sh"]