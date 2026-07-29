#
# Copyright (C) 2023 The 2by2 Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Soong namespaces.
# This repo declares a soong_namespace of its own in Android.bp, so without
# listing itself here none of its modules resolve -- MobileFeliCa* and the
# prebuilt NFC apps were being dropped silently by ALLOW_MISSING_DEPENDENCIES.
PRODUCT_SOONG_NAMESPACES += \
    vendor/motorola/felica-common

# Avoid compile errors
RELAX_USES_LIBRARY_CHECK := true

# Prebuilt FeliCa applications
PRODUCT_PACKAGES += \
    MobileFeliCaClient \
    MobileFeliCaMenuMainApp \
    MobileFeliCaSettingApp \
    MobileFeliCaWebPluginBoot

# NFC
# NQNfcNci and its libs are the stock (Android 12) NXP NFC app. Nothing here
# replaces AOSP's NfcNci any more: the prebuilt app cannot run on the Android 15
# framework, and RemovePackagesNfcNci used to strip AOSP's app while NQNfcNci was
# unresolvable, leaving the ROM with no NFC application at all.
# FeliCa off-host routing is configured in the NXP HAL conf instead
# (DEFAULT_NFCF_ROUTE / DEFAULT_SYS_CODE_ROUTE, see device/motorola/cypfr).
PRODUCT_PACKAGES += \
    Tag

# FeliCa configs
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/blobs/system_ext/etc/sysconfig/com.felicanetworks.powersave.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/sysconfig/com.felicanetworks.powersave.xml \
    $(LOCAL_PATH)/blobs/product/etc/felica/common.cfg:$(TARGET_COPY_OUT_PRODUCT)/etc/felica/common.cfg \
    $(LOCAL_PATH)/blobs/product/etc/felica/mfm.cfg:$(TARGET_COPY_OUT_PRODUCT)/etc/felica/mfm.cfg \
    $(LOCAL_PATH)/blobs/product/etc/felica/mfs.cfg:$(TARGET_COPY_OUT_PRODUCT)/etc/felica/mfs.cfg

# blobs/system/etc/libnfc-nci.conf is deliberately not installed. Its values are
# for a different board (NFA_MAX_EE_SUPPORTED=0x02 vs 0x03, POLLING_TECH_MASK
# =0x2F vs 0x0F, no DEFAULT_SYS_CODE) and it also collides with the copy AOSP's
# NfcNci installs. cypfr gets /vendor/etc/libnfc-nci_SN100.conf instead, which is
# what persist.nfc_cfg.config_file_name points at.

# Permissions
$(foreach f, $(wildcard $(LOCAL_PATH)/blobs/system/etc/permissions/*.xml), \
    $(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/$(notdir $f)))
$(foreach f, $(wildcard $(LOCAL_PATH)/blobs/product/etc/permissions/*.xml), \
    $(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/$(notdir $f)))
$(foreach f, $(wildcard $(LOCAL_PATH)/blobs/system_ext/etc/permissions/*.xml), \
    $(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/$(notdir $f)))

# Framework jars
$(foreach f, $(wildcard $(LOCAL_PATH)/blobs/system/framework/*.jar), \
    $(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM)/framework/$(notdir $f)))
$(foreach f, $(wildcard $(LOCAL_PATH)/blobs/system_ext/framework/*.jar), \
    $(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM_EXT)/framework/$(notdir $f)))

# Libraries
$(foreach f, $(wildcard $(LOCAL_PATH)/blobs/system_ext/lib/*.so), \
    $(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM_EXT)/lib/$(notdir $f)))
$(foreach f, $(wildcard $(LOCAL_PATH)/blobs/system_ext/lib64/*.so), \
    $(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM_EXT)/lib64/$(notdir $f)))
