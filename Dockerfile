FROM debian:12.1

LABEL maintainer="Dschinghis Kahn"

####################################################
######### DEFAULT VALUES                 ###########
####################################################
ENV TIMEZONE=UTC
ENV FHEM_VERSION=6.0

####################################################
######### INSTALLING BASE STUFF          ###########
####################################################
RUN \
  apt-get update && \
  apt-get install -y \
    tzdata \
    procps \
    wget \
    libjson-perl \
    libio-socket-ssl-perl \
    libdevice-serialport-perl \
    libxml-simple-perl \
    libhtml-tableextract-perl \
    liblwp-protocol-https-perl \
    librpc-xml-perl

####################################################
######### INSTALLING FHEM                ###########
####################################################
RUN \
  cd /tmp && \
  wget http://fhem.de/fhem-${FHEM_VERSION}.tar.gz && \
  tar -xzf fhem-${FHEM_VERSION}.tar.gz -C /opt && \
  mv /opt/fhem-${FHEM_VERSION} /opt/fhem && \
  cat /opt/fhem/fhem.cfg | sed -e s'/attr global logfile \.\/log\/fhem-%Y-%m.log/attr global logfile \.\/log\/fhem.log/' > /etc/fhem.cfg

####################################################
######### SETUP FILES & FOLDERS          ###########
####################################################
COPY init /
COPY update.cfg /opt/fhem

####################################################
######### CLEANUP                        ###########
####################################################
RUN rm -rf /tmp/* /root/.cache

EXPOSE 8083/TCP

HEALTHCHECK CMD nc -z localhost 8083 || exit 1

CMD ["/init"]
