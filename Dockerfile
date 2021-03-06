FROM python:3.8-slim

LABEL maintainer "Kyrylo Malakhov <malakhovks@nas.gov.ua>"
LABEL description "Stanza library inside docker container demo."

COPY . /stanza/serv
WORKDIR /stanza/serv

RUN apt-get -y clean \
    && apt-get -y update \
    && apt-get -y install nginx \
    && apt-get -y install python-dev \
    && apt-get -y install build-essential \
    && apt-get -y install curl \
    && apt-get -y install wget \
    && apt-get -y install unzip \
    && curl https://getmic.ro | bash \
    # ------------------------------------------------------------------
    && pip install -r ./deploy/requirements.txt --src /usr/local/src \
    # * Preload NB stanza resources
    && python -c 'import stanza; stanza.download("nb")' \
    && rm -r /root/.cache \
    && apt-get -y clean \
    && apt-get -y autoremove

# Preload EN stanza resources
# RUN wget https://raw.githubusercontent.com/stanfordnlp/stanza-resources/master/resources_1.1.0.json -P ~/stanza_resources
# RUN wget https://nlp.stanford.edu/software/stanza/1.1.0/nb/default.zip -P ~/stanza_resources/nb
# RUN unzip ~/stanza_resources/nb/default.zip -d ~/stanza_resources/nb
# RUN rm ~/stanza_resources/nb/default.zip
# RUN mv ~/stanza_resources/resources_1.1.0.json ~/stanza_resources/resources.json

COPY ./deploy/nginx.conf /etc/nginx

# RUN chmod -R a+rwx /stanza/serv

RUN chmod +x ./start.sh
CMD ["./start.sh"]