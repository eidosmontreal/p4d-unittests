FROM ubuntu:xenial

RUN  apt-get update \
  && apt-get install -y wget \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV SERVER_NAME perforce

# initial depot name
ENV DEPOT_NAME unittests

#multiple valid user names separated by a space
ENV DEPOT_USERS unittest-user

ENV P4PORT 1666
ENV P4USER p4admin
ENV P4PASSWD p4admin@123

# Add the perforce apt key
# Add the perforce public key
RUN wget -qO - https://package.perforce.com/perforce.pubkey | apt-key add -

RUN echo "deb http://package.perforce.com/apt/ubuntu xenial release" | tee /etc/apt/sources.list.d/perforce.list

# Install the perforce server and dependent packages
RUN apt-get update && \
    apt-get install -y net-tools helix-p4d

# Expose default p4d connector port
EXPOSE 1666

# Set volume mount point for server roots and triggers and configuration
VOLUME /opt/perforce/servers
VOLUME /opt/perforce/triggers
VOLUME /etc/perforce

# Add a startup file
ADD ./run.sh /
ADD ./noauth.sh /

# Run the file
CMD ["/run.sh"]