#
# ESP-OPEN-SDK builder
#
FROM ubuntu:18.04 as esp-open-sdk-builder
MAINTAINER  Stellars Henson <konrad.jelen@gmail.com>


# Install build dependencies (and vim + picocom for editing/debugging)
RUN apt-get -qq update \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y make unrar-free autoconf automake libtool gcc g++ \
    gperf flex bison texinfo gawk ncurses-dev libexpat-dev python-dev python sed git unzip \
    bash help2man wget bzip2 libtool-bin python-serial \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Get the esp-open-sdk
RUN git clone --recursive https://github.com/pfalcon/esp-open-sdk.git /opt/esp-open-sdk \
#    && echo "CT_EXPERIMENTAL=y" >> /esp-open-sdk/crosstool-config-overrides \
    && echo "CT_ALLOW_BUILD_AS_ROOT=y" >> /opt/esp-open-sdk/crosstool-config-overrides \
    && echo "CT_ALLOW_BUILD_AS_ROOT_SURE=y" >> /opt/esp-open-sdk/crosstool-config-overrides

#fix error with the expat 2.1 and change version to 2.3 for SDK build
RUN cd /opt/esp-open-sdk/crosstool-NG/config/companion_libs && cat expat.in | sed s/2_1/2_3/g | sed s/2\.1/2\.3/g > expat.in.new && mv expat.in.new expat.in

# Build the esp-open-sdk
# Clean out large and now unnecessary crosstool-NG build area
RUN cd /opt/esp-open-sdk && make toolchain esptool libhal STANDALONE=n
RUN rm -fr /opt/esp-open-sdk/crosstool-NG

#
# ESP-OPEN-RTOS builder
#
FROM ubuntu:18.04 as esp-open-rtos-builder

RUN apt-get -qq update \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y make \
    gcc \
    picocom \
    python \
    python-serial \
    git \
    bash \
    mc \
    vim \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# copy sdk toolchain
COPY --from=esp-open-sdk-builder /opt/esp-open-sdk /opt/esp-open-sdk


# Get the esp-open-rtos SDK
RUN git clone --recursive https://github.com/SuperHouse/esp-open-rtos.git /opt/esp-open-rtos

# Add ESP_OPEN_RTOS variable to point to path so that makefiles don't *have* to live in the
# examples directory (will require your makefile to reference $(ESP_OPEN_RTOS)/common.mk

# default project directory (map this with your custom project)
ENV SDK_PATH=/opt/esp-open-rtos
ENV PATH="/opt/esp-open-sdk/xtensa-lx106-elf/bin:${PATH}"

# projects will be mapped here
WORKDIR /opt/esp-open-rtos/examples/project

# To keep container running
CMD tail -f /dev/null
