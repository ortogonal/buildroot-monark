################################################################################
#
# qtuio
#
################################################################################

BLUEPOWER_VERSION = 8173097dc69ed3faaf56e0316346281027d16338
BLUEPOWER_SITE = $(call github,ortogonal,bluepower,$(BLUEPOWER_VERSION))
BLUEPOWER_DEPENDENCIES = qt5base qt5connectivity qt5websockets qt5webchannel

BLUEPOWER_LICENSE = GPL-3.0+
BLUEPOWER_LICENSE_FILES = COPYING


define BLUEPOWER_CONFIGURE_CMDS
	cd $(@D) && $(TARGET_MAKE_ENV) $(QT5_QMAKE)
endef

define BLUEPOWER_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define BLUEPOWER_INSTALL_TARGET_LIBRARY
	cp -dpf $(@D)/bluepower $(TARGET_DIR)/usr/bin
endef

define BLUEPOWER_INSTALL_TARGET_CMDS
	$(BLUEPOWER_INSTALL_TARGET_LIBRARY)
endef

define BLUEPOWER_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/bluepower/bluepower.service \
		$(TARGET_DIR)/usr/lib/systemd/system/bluepower.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -fs ../../../../usr/lib/systemd/system/bluepower.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/bluepower.service
	$(INSTALL) -D -m 644 package/bluepower/hciattach.service \
		$(TARGET_DIR)/usr/lib/systemd/system/hciattach.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -fs ../../../../usr/lib/systemd/system/hciattach.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/hciattach.service
endef

$(eval $(generic-package))
