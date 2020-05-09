FROM alpine:latest

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
  echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
  apk add --no-cache \
    tzdata \
    perl-json \
    perl-io-socket-ssl \
    perl-device-serialport \
    perl-xml-simple \
    perl-html-parser \
    perl-html-tableextract

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

####################################################
######### CLEANUP                        ###########
####################################################
RUN rm -rf /tmp/* /root/.cache

EXPOSE 8083/TCP

CMD ["/init"]
