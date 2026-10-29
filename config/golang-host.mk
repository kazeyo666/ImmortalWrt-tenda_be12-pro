# ARM64 self-hosted runner: use a checksum-pinned official host toolchain.
include $(TOPDIR)/rules.mk

PKG_NAME:=golang
PKG_VERSION:=1.27.3
PKG_RELEASE:=1
PKG_LICENSE:=BSD-3-Clause
PKG_LICENSE_FILES:=LICENSE
PKG_HOST_ONLY:=1

PKG_SOURCE:=go$(PKG_VERSION).linux-arm64.tar.gz
PKG_SOURCE_URL:=https://dl.google.com/go/
PKG_HASH:=a06e99309dbcbdca1a8ccd2282c3ee146e55930886e26b4f1193269587165f49
HOST_BUILD_DIR:=$(BUILD_DIR_HOST)/go-$(PKG_VERSION)-linux-arm64
HOST_UNPACK=$(HOST_TAR) -C "$(HOST_BUILD_DIR)" --strip-components=1 -xzf "$(DL_DIR)/$(PKG_SOURCE)"

include $(INCLUDE_DIR)/host-build.mk
include $(INCLUDE_DIR)/package.mk

define Package/golang
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=Go host toolchain for the ARM64 runner
  BUILDONLY:=1
endef

define Host/Configure
	@test "`uname -sm`" = "Linux aarch64"
	$(HOST_BUILD_DIR)/bin/go version
endef

define Host/Compile
endef

define Host/Install
	rm -rf $(STAGING_DIR_HOSTPKG)/lib/go-cross
	$(INSTALL_DIR) $(STAGING_DIR_HOSTPKG)/lib/go-cross $(STAGING_DIR_HOSTPKG)/bin
	$(CP) $(HOST_BUILD_DIR)/. $(STAGING_DIR_HOSTPKG)/lib/go-cross/
	$(LN) ../lib/go-cross/bin/go $(STAGING_DIR_HOSTPKG)/bin/go
	$(LN) ../lib/go-cross/bin/gofmt $(STAGING_DIR_HOSTPKG)/bin/gofmt
endef

$(eval $(call HostBuild))
$(eval $(call BuildPackage,golang))
