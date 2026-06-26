ARCHS = arm64 arm64e
INSTALL_TARGET_PROCESSES = Instagram
export THEOS=/Users/kaanarslan/theos/

TARGET := iphone:clang:latest:16.0
THEOS_PACKAGE_SCHEME=rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = IGOledTheme
IGOledTheme_FILES = Tweak.xm
IGOledTheme_CFLAGS = -fobjc-arc -Wno-deprecated-declarations -Wno-unused-variable -Wno-unused-value -Wno-unused-function -Wno-unused-variable
IGOledTheme_LDFLAGS = -lobjc -lstdc++
IGOledTheme_LOGOSFLAGS = --c warnings=n

include $(THEOS_MAKE_PATH)/tweak.mk

