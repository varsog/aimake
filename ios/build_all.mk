
#
# objects
#
LOCAL_SRC_FILES_EXCLUDE += $(shell find $(LOCAL_SRC_DIRS_EXCLUDE) -name "*.c" -or -name "*.cpp")

LOCAL_SRC_FILES += $(shell find $(LOCAL_SRC_DIRS) -name "*.c" -or -name "*.cpp")
LOCAL_SRC_FILES := $(filter-out $(LOCAL_SRC_FILES_EXCLUDE), $(LOCAL_SRC_FILES))

OBJECTS_IOS_DEV_ARMV6 = $(subst .c,_ios_dev_armv6.o,$(subst .cpp,_ios_dev_armv6.o,$(LOCAL_SRC_FILES)))
OBJECTS_IOS_DEV_ARMV7 = $(subst .c,_ios_dev_armv7.o,$(subst .cpp,_ios_dev_armv7.o,$(LOCAL_SRC_FILES)))
OBJECTS_IOS_SIM_I386  = $(subst .c,_ios_sim_i386.o, $(subst .cpp,_ios_sim_i386.o, $(LOCAL_SRC_FILES)))


#
# build targets
#
EXECUTABLE               = $(LOCAL_MODULE)
EXECUTABLE_IOS_DEV_ARMV6 = $(LOCAL_MODULE)_ios_dev_armv6
EXECUTABLE_IOS_DEV_ARMV7 = $(LOCAL_MODULE)_ios_dev_armv7
EXECUTABLE_IOS_SIM_I386  = $(LOCAL_MODULE)_ios_sim_i386

STATIC_LIBRARY               = lib$(LOCAL_MODULE).a
STATIC_LIBRARY_IOS_DEV_ARMV6 = lib$(LOCAL_MODULE)_ios_dev_armv6.a
STATIC_LIBRARY_IOS_DEV_ARMV7 = lib$(LOCAL_MODULE)_ios_dev_armv7.a
STATIC_LIBRARY_IOS_SIM_I386  = lib$(LOCAL_MODULE)_ios_sim_i386.a

SHARED_LIBRARY               = lib$(LOCAL_MODULE).dylib
SHARED_LIBRARY_IOS_DEV_ARMV6 = lib$(LOCAL_MODULE)_ios_dev_armv6.dylib
SHARED_LIBRARY_IOS_DEV_ARMV7 = lib$(LOCAL_MODULE)_ios_dev_armv7.dylib
SHARED_LIBRARY_IOS_SIM_I386  = lib$(LOCAL_MODULE)_ios_sim_i386.dylib

PACKAGE  = $(LOCAL_MODULE)_$(TARGET_PLATFORM)_$(VERSION).tar.gz

#
# explict rules
#
%_ios_dev_armv6.o : %.c
	$(CC_IOS_DEV) $(LOCAL_CFLAGS) $(CFLAGS_IOS_DEV_ARMV6) -c $< -o $@

%_ios_dev_armv7.o : %.c
	$(CC_IOS_DEV) $(LOCAL_CFLAGS) $(CFLAGS_IOS_DEV_ARMV7) -c $< -o $@

%_ios_sim_i386.o  : %.c
	$(CC_IOS_SIM) $(LOCAL_CFLAGS) $(CFLAGS_IOS_SIM_I386)  -c $< -o $@

%_ios_dev_armv6.o : %.cpp
	$(CXX_IOS_DEV) $(LOCAL_CXXFLAGS) $(CXXFLAGS_IOS_DEV_ARMV6) -c $< -o $@

%_ios_dev_armv7.o : %.cpp
	$(CXX_IOS_DEV) $(LOCAL_CXXFLAGS) $(CXXFLAGS_IOS_DEV_ARMV7) -c $< -o $@

%_ios_sim_i386.o  : %.cpp
	$(CXX_IOS_SIM) $(LOCAL_CXXFLAGS) $(CXXFLAGS_IOS_SIM_I386)  -c $< -o $@


#
# goal: all
#
all: $(ALL)

$(EXECUTABLE) : $(EXECUTABLE_IOS_DEV_ARMV6) $(EXECUTABLE_IOS_DEV_ARMV7) $(EXECUTABLE_IOS_SIM_I386)
	lipo -output $@ -create -arch armv6 $(EXECUTABLE_IOS_DEV_ARMV6) -arch armv7 $(EXECUTABLE_IOS_DEV_ARMV7) -arch i386 $(EXECUTABLE_IOS_SIM_I386)

$(EXECUTABLE_IOS_DEV_ARMV6) : $(OBJECTS_IOS_DEV_ARMV6)
	$(CXX_IOS_DEV) $^ $(LOCAL_CXXFLAGS) $(CXXFLAGS_IOS_DEV_ARMV6) $(LOCAL_LDFLAGS) $(LDFLAGS_IOS_DEV) -o $@

$(EXECUTABLE_IOS_DEV_ARMV7) : $(OBJECTS_IOS_DEV_ARMV7)
	$(CXX_IOS_DEV) $^ $(LOCAL_CXXFLAGS) $(CXXFLAGS_IOS_DEV_ARMV7) $(LOCAL_LDFLAGS) $(LDFLAGS_IOS_DEV) -o $@

$(EXECUTABLE_IOS_SIM_I386) : $(OBJECTS_IOS_SIM_I386)
	$(CXX_IOS_SIM) $^ $(LOCAL_CXXFLAGS) $(CXXFLAGS_IOS_SIM_I386) $(LOCAL_LDFLAGS)  $(LDFLAGS_IOS_SIM) -o $@


$(SHARED_LIBRARY) : $(SHARED_LIBRARY_IOS_DEV_ARMV6) $(SHARED_LIBRARY_IOS_DEV_ARMV7) $(SHARED_LIBRARY_IOS_SIM_I386)
	lipo -output $@ -create -arch armv6 $(SHARED_LIBRARY_IOS_DEV_ARMV6) -arch armv7 $(SHARED_LIBRARY_IOS_DEV_ARMV7) -arch i386 $(SHARED_LIBRARY_IOS_SIM_I386)

$(SHARED_LIBRARY_IOS_DEV_ARMV6) : $(OBJECTS_IOS_DEV_ARMV6)
	$(CXX_IOS_DEV) $^ $(LOCAL_CXXFLAGS) $(CXXFLAGS_IOS_DEV_ARMV6) $(LOCAL_LDFLAGS) $(LDFLAGS_IOS_DEV) -o $@

$(SHARED_LIBRARY_IOS_DEV_ARMV7) : $(OBJECTS_IOS_DEV_ARMV7)
	$(CXX_IOS_DEV) $^ $(LOCAL_CXXFLAGS) $(CXXFLAGS_IOS_DEV_ARMV7) $(LOCAL_LDFLAGS) $(LDFLAGS_IOS_DEV) -o $@

$(SHARED_LIBRARY_IOS_SIM_I386) : $(OBJECTS_IOS_SIM_I386)
	$(CXX_IOS_SIM) $^ $(LOCAL_CXXFLAGS) $(CXXFLAGS_IOS_SIM_I386) $(LOCAL_LDFLAGS)  $(LDFLAGS_IOS_SIM) -o $@


$(STATIC_LIBRARY) : $(STATIC_LIBRARY_IOS_DEV_ARMV6) $(STATIC_LIBRARY_IOS_DEV_ARMV7) $(STATIC_LIBRARY_IOS_SIM_I386)
	lipo -output $@ -create -arch armv6 $(STATIC_LIBRARY_IOS_DEV_ARMV6) -arch armv7 $(STATIC_LIBRARY_IOS_DEV_ARMV7) -arch i386 $(STATIC_LIBRARY_IOS_SIM_I386)

$(STATIC_LIBRARY_IOS_DEV_ARMV6) : $(OBJECTS_IOS_DEV_ARMV6)
	$(AR_IOS_DEV) crv $@ $^

$(STATIC_LIBRARY_IOS_DEV_ARMV7) : $(OBJECTS_IOS_DEV_ARMV7)
	$(AR_IOS_DEV) crv $@ $^

$(STATIC_LIBRARY_IOS_SIM_I386)  : $(OBJECTS_IOS_SIM_I386)
	$(AR_IOS_SIM) crv $@ $^

#
# goal: clean
#
clean:
	rm -rf $(EXECUTABLE) $(EXECUTABLE_IOS_DEV_ARMV6) $(EXECUTABLE_IOS_DEV_ARMV7) $(EXECUTABLE_IOS_SIM_I386)  $(STATIC_LIBRARY) $(STATIC_LIBRARY_IOS_DEV_ARMV6) $(STATIC_LIBRARY_IOS_DEV_ARMV7) $(STATIC_LIBRARY_IOS_SIM_I386) $(PACKAGE) $(OBJECTS_IOS_DEV_ARMV6) $(OBJECTS_IOS_DEV_ARMV7) $(OBJECTS_IOS_SIM_I386)

#
# goal: package
#
ifeq ($(findstring package,$(MAKECMDGOALS)),package)
    ifeq ($(VERSION),)
        $(error require argument 'VERSION' for 'package' goal)
    endif
    ifeq ($(PACKAGE_RESOURCES),)
    endif
endif

PACKAGE_TEMP_DIR = $(PACKAGE:.tar.gz=)
package: $(PACKAGE)
$(PACKAGE): $(ALL)
	@[ -e $(PACKAGE_TEMP_DIR) ] && echo "$(PACKAGE_TEMP_DIR) already exist, please delete it manually" && exit;\
	rm -rf $(PACKAGE_TEMP_DIR);\
	rm -rf $@;
	mkdir -p $(PACKAGE_TEMP_DIR);
	cp -rf $(ALL) $(LOCAL_PACKAGE_RESOURCES) $(PACKAGE_TEMP_DIR);
	tar --exclude .svn -czf $@ $(PACKAGE_TEMP_DIR);
	rm -rf $(PACKAGE_TEMP_DIR); 