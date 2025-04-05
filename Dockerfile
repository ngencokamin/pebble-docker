FROM --platform=linux/amd64 python:2.7-buster

# update system and get base packages
RUN apt-get update && \
    apt-get install -y curl libfreetype6-dev bash-completion libsdl1.2debian \
                       libfdt1 libpixman-1-0 libglib2.0-dev && \
    apt-get install -y vim screen && \
    apt-get install -y nodejs npm && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set version
ENV PEBBLE_TOOL_VERSION pebble-sdk-4.6-rc2-linux64
ENV PEBBLE_SDK_VERSION 4.3

# Get pebble tool
RUN curl -sSL https://rebble-sdk.s3-us-west-2.amazonaws.com/${PEBBLE_TOOL_VERSION}.tar.bz2 | tar -C /opt/ -xj
RUN ls /opt

# Prepare Python environment
WORKDIR /opt/${PEBBLE_TOOL_VERSION}
RUN /bin/bash -c " \
		virtualenv .env && \
		source .env/bin/activate && \
		pip install -r requirements.txt && \
		deactivate" && \
	rm -r /root/.cache/

# Install emulator dependencies
RUN apt-get install -y libsdl1.2debian libfdt1 libpixman-1-0

# Create pebble user for build environment
RUN adduser --disabled-password --gecos "" --ingroup users pebble && \
    echo "pebble ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    chmod -R 777 "/opt/$PEBBLE_TOOL_VERSION" && \
    mkdir -p /home/pebble/.pebble-sdk && \
    chown -R pebble:users /home/pebble/.pebble-sdk && \
    touch /home/pebble/.pebble-sdk/NO_TRACKING

# Change to pebble user
USER pebble

# set PATH
ENV PATH /opt/${PEBBLE_TOOL_VERSION}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Install sdk
RUN wget https://github.com/aveao/PebbleArchive/raw/master/SDKCores/sdk-core-${PEBBLE_SDK_VERSION}.tar.bz2
RUN pebble sdk install ./sdk-core-${PEBBLE_SDK_VERSION}.tar.bz2 && pebble sdk activate ${PEBBLE_SDK_VERSION}

# Prepare mount path
VOLUME /pebble/

# Run Commands
WORKDIR /pebble/
CMD /bin/bash
