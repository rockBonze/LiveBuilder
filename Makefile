#!/bin/sh

# (C) 2012-2016 Fathi Boudra <fathi.boudra@linaro.org>

# Calls all necessary live-build programs in the correct order to complete
# the bootstrap, chroot, binary, and source stage.

# You need live-build package installed and superuser privileges.

BUILD_DIR=./build
CHROOT=$(BUILD_DIR)/chroot
BINARY=$(BUILD_DIR)/binary
MERGE_DIR=./packages
VERSION=1.0

BASEIMG=ubuntu-focal-$(VERSION)
IMAGEPREFIX=$(BASEIMG)-`date +%Y%m%d`
LOGFILE=$(IMAGEPREFIX).build-log.txt
CONFIGFILE=$(IMAGEPREFIX).config.tar.bz2
LISTFILE=$(IMAGEPREFIX).contents
PKGSFILE=$(IMAGEPREFIX).packages
TARGZFILE=$(IMAGEPREFIX).tar.gz
MD5SUMSFILE=$(IMAGEPREFIX).md5sums.txt
SHA1SUMSFILE=$(IMAGEPREFIX).sha1sums.txt

all:
	set -e; 
	@if [ ! -d $(BUILD_DIR) ]; then \
		mkdir build; \
	fi
	cd $(BUILD_DIR) && sudo lb build 2>&1 | tee $(LOGFILE)
	if [ -f $(BUILD_DIR)/binary-tar.tar.gz ]; then \
		cd $(BUILD_DIR) && \
		tar -jcf $(CONFIGFILE) auto/ config/; \
		sudo mv binary.contents $(LISTFILE); \
		sudo mv chroot.packages.live $(PKGSFILE); \
		sudo mv binary-tar.tar.gz $(TARGZFILE); \
		md5sum $(LOGFILE) $(CONFIGFILE) $(LISTFILE) $(PKGSFILE) $(TARGZFILE) > $(MD5SUMSFILE); \
		sha1sum $(LOGFILE) $(CONFIGFILE) $(LISTFILE) $(PKGSFILE) $(TARGZFILE) > $(SHA1SUMSFILE); \
	fi

prepare:
	@if [ -f ./script/make_prepare ]; then \
        ./script/make_prepare; \
    else \
		echo "make prepare error, ./script/make_prepare not exits."; \
	fi

config:
	@if [ -f ./script/configure ]; then \
		./script/configure; \
	else \
		echo "make config error: ./script/configure not exist."; \
	fi

deb:
	@if [ -f ./script/build_deb ]; then \
		./script/build_deb; \
	else \
		echo "make deb error: ./script/build_deb not exist."; \
	fi

ubuntu:
	@if [ -f ./script/make_image ]; then \
		./script/make_image; \
	else \
		echo "make image error: ./script/make_image not exist."; \
	fi

chroot:
	@if [ ! -d $(BINARY) ]; then \
		echo "make chroot error: $(BINARY) not exist."; \
		exit 1; \
	fi
	
	@if [ -f ./script/chroot_binary ]; then \
		./script/chroot_binary $(BINARY) start; \
	else \
		echo "make chroot error: ./script/chroot_binary not exist."; \
	fi

unchroot:
	@if [ ! -d $(BINARY) ]; then \
		echo "make unchroot error: $(BINARY) not exist."; \
		exit 1; \
	fi
	
	@if [ -f ./script/chroot_binary ]; then \
		./script/chroot_binary $(BINARY) stop; \
		./script/chroot_binary $(BINARY) stop; \
		./script/chroot_binary $(BINARY) clean; \
	else \
		echo "make unchroot error: ./script/chroot_binary not exist."; \
	fi

clean:
	cd $(BUILD_DIR) && sudo lb clean --binary
	cd $(BUILD_DIR) && sudo lb clean --stage
	rm -f $(BUILD_DIR)/$(BASEIMG)*
	rm -rf $(BUILD_DIR)/config
	rm -rf $(BUILD_DIR)/image

deepclean:
	cd $(BUILD_DIR) && sudo lb clean --purge
	rm -f $(BUILD_DIR)/$(BASEIMG)*
	rm -rf $(BUILD_DIR)/config
	rm -rf $(BUILD_DIR)/image
