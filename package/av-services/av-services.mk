################################################################################
#
# av-services
#
################################################################################

AV_SERVICES_SITE = $(TOPDIR)/../av_services
AV_SERVICES_SITE_METHOD = local
AV_SERVICES_LICENSE = Proprietary
AV_SERVICES_DEPENDENCIES = libcurl

# Build from the checked-out submodule in Stage1 and install the project's
# binaries and unit files through its CMake install rules.
AV_SERVICES_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release

define AV_SERVICES_INSTALL_DEFAULT_CONFIG
	$(INSTALL) -d $(TARGET_DIR)/etc/av-core
	$(INSTALL) -m 0644 $(BR2_EXTERNAL_MCHP_PATH)/package/av-services/files/gateway.conf \
		$(TARGET_DIR)/etc/av-core/gateway.conf
	$(INSTALL) -m 0644 $(BR2_EXTERNAL_MCHP_PATH)/package/av-services/files/health.conf \
		$(TARGET_DIR)/etc/av-core/health.conf
	$(INSTALL) -m 0644 $(BR2_EXTERNAL_MCHP_PATH)/package/av-services/files/logger.conf \
		$(TARGET_DIR)/etc/av-core/logger.conf
	$(INSTALL) -m 0644 $(BR2_EXTERNAL_MCHP_PATH)/package/av-services/files/ota.conf \
		$(TARGET_DIR)/etc/av-core/ota.conf
	$(INSTALL) -m 0644 $(BR2_EXTERNAL_MCHP_PATH)/package/av-services/files/orchestrator.conf \
		$(TARGET_DIR)/etc/av-core/orchestrator.conf
endef

AV_SERVICES_POST_INSTALL_TARGET_HOOKS += AV_SERVICES_INSTALL_DEFAULT_CONFIG

# The upstream project installs units into /etc/systemd/system. Enable the
# target so all av-core services start with multi-user boot.
define AV_SERVICES_INSTALL_INIT_SYSTEMD
	$(INSTALL) -d $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -snf /etc/systemd/system/av-core.target \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/av-core.target
	$(INSTALL) -d $(TARGET_DIR)/var/lib/av-core/ota
	$(INSTALL) -d $(TARGET_DIR)/var/log/av-core
endef

$(eval $(cmake-package))
