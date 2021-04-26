FROM ubuntu:18.04 

# Install build dependencies (and vim + picocom for editing/debugging)
RUN apt-get -qq update \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y make unrar-free autoconf automake libtool gcc g++ \
    gperf flex bison texinfo gawk ncurses-dev libexpat-dev python-dev python sed git unzip \ 
    bash help2man wget bzip2 libtool-bin python-serial mc vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Get the esp-open-sdk
RUN git clone --recursive https://github.com/pfalcon/esp-open-sdk.git /opt/esp-open-sdk \
#    && echo "CT_EXPERIMENTAL=y" >> /esp-open-sdk/crosstool-config-overrides \
    && echo "CT_ALLOW_BUILD_AS_ROOT=y" >> /opt/esp-open-sdk/crosstool-config-overrides \
    && echo "CT_ALLOW_BUILD_AS_ROOT_SURE=y" >> /opt/esp-open-sdk/crosstool-config-overrides

#fix error with the expat 2.1 and change version to 2.3 for SDK build
RUN cd /opt/esp-open-sdk/crosstool-NG/config/companion_libs && cat expat.in | sed s/2_1/2_3/g | sed s/2\.1/2\.3/g > expat.in.new && mv expat.in.new expat.in

# Add ESP_OPEN_RTOS variable to point to path so that makefiles don't *have* to live in the
# examples directory (will require your makefile to reference $(ESP_OPEN_RTOS)/common.mk
ENV ESP_OPEN_RTOS=/opt/esp-open-rtos

# Get the esp-open-rtos SDK
RUN git clone --recursive https://github.com/SuperHouse/esp-open-rtos.git $ESP_OPEN_RTOS

# Build the esp-open-sdk
# Clean out large and now unnecessary crosstool-NG build area
RUN cd /opt/esp-open-sdk && make toolchain esptool libhal STANDALONE=n 
RUN rm -fr /opt/esp-open-sdk/crosstool-NG

# default project directory (map this with your custom project)
ENV PATH="/opt/esp-open-sdk/xtensa-lx106-elf/bin:${PATH}"
WORKDIR /opt/esp-open-rtos/examples/project

