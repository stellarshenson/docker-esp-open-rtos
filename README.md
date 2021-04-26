esp-open-rtos Build Environment
===============================

[![Docker Pulls](https://img.shields.io/docker/pulls/beetix/esp-open-rtos.svg)](https://hub.docker.com/r/beetix/esp-open-rtos/) [![Docker Stars](https://img.shields.io/docker/stars/beetix/esp-open-rtos.svg)](https://hub.docker.com/r/beetix/esp-open-rtos/) [![](https://images.microbadger.com/badges/image/beetix/esp-open-rtos.svg)](https://microbadger.com/images/beetix/esp-open-rtos "Get your own image badge on microbadger.com") [![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/beetix/esp-build/blob/master/LICENSE)

Based on https://github.com/bschwind/esp-build and https://github.com/malachi-iot/esp-build

This Dockerfile contains the dependencies necessary to create a toolchain for the ESP8266 chip.
It is based on [esp-open-rtos](https://github.com/SuperHouse/esp-open-rtos) and allows for easy building and flashing
to the ESP8266 chip for projects written with esp-open-rtos.

Quick Setup
-----------

* `docker pull beetix/esp-open-rtos`
* `cd` to your esp-open-rtos project
* Without USB flashing support: `docker run --rm -it -v $(PWD):/esp-open-rtos/examples/project beetix/esp-open-rtos /bin/bash`
* With USB flashing support:
  * docker-machine: `docker run --rm -it --privileged -v /dev/bus/usb:/dev/bus/usb -v $(PWD):/esp-open-rtos/examples/project beetix/esp-open-rtos /bin/bash`
  * Linux: `docker run --rm -it --device=/dev/ttyUSB0 -v $PWD:/esp-open-rtos/examples/project beetix/esp-open-rtos /bin/bash`

Using docker-machine
--------------------

If you're on docker-machine (OS X or Windows), you need to forward your USB device within Virtualbox. This is best managed in the VirtualBox GUI.

Steps:

* Stop your docker virtual machine host, if applicable
* Plug in the USB serial device you will use to flash to the ESP8266
* Install [virtualbox extensions](https://www.virtualbox.org/wiki/Downloads) to support USB (Ctrl-F "extension" on that page)
  * OS X -> Under "Virtualbox" -> Preferences, go to the Extensions tab
  * Windows -> Same thing?
  * Click the "Adds new package" button and select the extension pack you downloaded
* Return to the main VirtualBox GUI
* Right click on your docker VM and select "Settings"
* Select "Ports" -> "USB"
* Check the box "Enable USB Controller" and select "USB 2.0 (EHCI) Controller"
* Under "USB Device Filters" click the USB icon with the green plus sign to add a USB device
* Select your USB serial device (in my case it was "FTDI FT232R USB UART [0600]")
* Click OK until you're back to the main Virtualbox GUI
* At this point you can restart your virtual machine with `docker-machine start <YOUR_DOCKER_VM_NAME>`
* Run docker as we did in Quick Setup: `docker run --rm -it --privileged -v /dev/bus/usb:/dev/bus/usb -v $(PWD):/home/esp/esp-open-rtos/examples/project beetix/esp-open-rtos /bin/bash`
  * NOTE: With the `-v /dev/bus/usb:/dev/bus/usb` volume, the `/dev/bus/usb` on the lefthand side of the colon refers to docker VM's USB directory, *not* your host machine (you likely won't find that path on OS X)
* `/dev/ttyUSB0` should now be available

Building and Flashing Images from the Container
----------------------------------

* Run `make` and then `make flash` on an example project or your own (under `/esp-open-rtos/examples`)
* Flashing baud rate can be changed with the environment variable ESPBAUD passed into the `docker run` command

Serial Debugging
----------------

[Picocom](https://github.com/npat-efault/picocom) is installed in this image by default. Invoke it with `picocom -b 115200 /dev/ttyUSB0` (change the baud rate and device path accordingly)

Stop it with `Ctrl-A Ctrl-X`

Overriding the default esp-open-rtos
-----------------------------------

Using docker volumes you can override the default esp-open-rtos sources. Add `-v /path/to/custom/esp-open-rtos:/esp-open-rtos` into the `docker run` command
