esp-open-rtos Build Environment
===============================
This Dockerfile contains the dependencies necessary to create a toolchain for the ESP8266 chip.
It is based on [esp-open-rtos](https://github.com/SuperHouse/esp-open-rtos) and allows for easy building and flashing to the ESP8266 chip for projects written with esp-open-rtos.

Quick Setup
-----------

* `docker build . stellars/esp-open-rtos` or run `build.sh`
* Without USB flashing support: `docker run --rm -it -v $(pwd):/opt/esp-open-rtos/examples/project stellars/esp-open-rtos /bin/bash`
* Without USB flashing support: use examples/docker-compose.yml. Put in your project root and run `docker-compose up` after which `docker exec -it esp-open-rtos make`. This method is efficient as it keeps the container running and caches previous builds. Shell script `run.sh` does the same thing and starts the container if it is not running.
* With USB flashing support:
  * Linux: `docker run --rm -it --device=/dev/ttyUSB0 -v $(pwd):/esp-open-rtos/examples/project stellars/esp-open-rtos /bin/bash`

Building and Flashing Images from the Container
----------------------------------

* Run `make` and then `make flash` on an example project or your own (under `/esp-open-rtos/examples`)
* Flashing baud rate can be changed with the environment variable ESPBAUD passed into the `docker run` command

Serial Debugging
----------------

[Picocom](https://github.com/npat-efault/picocom) is installed in this image by default. Invoke it with `picocom -b 115200 /dev/ttyUSB0` (change the baud rate and device path accordingly)

Stop it with `Ctrl-A Ctrl-X`


