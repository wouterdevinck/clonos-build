all: build

.PHONY: prepare
prepare:
	./build.sh prepare

.PHONY: menuconfig
menuconfig:
	./build.sh menuconfig

.PHONY: build
build:
	./build.sh build

.PHONY: flash
flash:
	./build.sh flash

.PHONY: monitor
monitor:
	./build.sh monitor

.PHONY: clean
clean:
	./build.sh clean