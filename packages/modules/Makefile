#!/bin/sh

PKG_NAME:=kernel-modules
PKG_DESC:=Kernel modules for Linux 5.10.160
VERSION:=1.0.0
ARCH:=arm64
MAINTAINER:=bonze
PKG_DIR:=./files
PKG_CONTROL:=$(PKG_DIR)/DEBIAN/control

DEB_NAME:=$(PKG_NAME)_$(VERSION)_$(ARCH).deb
DEB_DIR:=../../build/deb_packages
ENABLED:=1

all: control deb-install

control:
	@mkdir -p $(PKG_DIR)/DEBIAN
	@echo "Package: $(PKG_NAME)" > $(PKG_CONTROL)
	@echo "Description: $(PKG_DESC)" >> $(PKG_CONTROL)
	@echo "Version: $(VERSION)" >> $(PKG_CONTROL)
	@echo "Architecture: $(ARCH)" >> $(PKG_CONTROL)
	@echo "Maintainer: $(MAINTAINER)" >> $(PKG_CONTROL)

deb-install: control
ifeq ($(ENABLED), 1)
	@echo "Building ${DEB_NAME} Package ..."
	@dpkg-deb --build $(PKG_DIR) $(DEB_NAME)
	@mkdir -p $(DEB_DIR)
	@[ -f $(DEB_NAME) ] && mv $(DEB_NAME) $(DEB_DIR)
else
	@echo "Skipping Building ${DEB_NAME} Package, ENABLED is not 1..."
endif
