# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.2

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list

# Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/binghao/cnn/24net/singletest

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/binghao/cnn/24net/singletest/build

# Include any dependencies generated for this target.
include CMakeFiles/singletest.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/singletest.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/singletest.dir/flags.make

CMakeFiles/singletest.dir/singletest.c.o: CMakeFiles/singletest.dir/flags.make
CMakeFiles/singletest.dir/singletest.c.o: ../singletest.c
	$(CMAKE_COMMAND) -E cmake_progress_report /home/binghao/cnn/24net/singletest/build/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building C object CMakeFiles/singletest.dir/singletest.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -o CMakeFiles/singletest.dir/singletest.c.o   -c /home/binghao/cnn/24net/singletest/singletest.c

CMakeFiles/singletest.dir/singletest.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/singletest.dir/singletest.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -E /home/binghao/cnn/24net/singletest/singletest.c > CMakeFiles/singletest.dir/singletest.c.i

CMakeFiles/singletest.dir/singletest.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/singletest.dir/singletest.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -S /home/binghao/cnn/24net/singletest/singletest.c -o CMakeFiles/singletest.dir/singletest.c.s

CMakeFiles/singletest.dir/singletest.c.o.requires:
.PHONY : CMakeFiles/singletest.dir/singletest.c.o.requires

CMakeFiles/singletest.dir/singletest.c.o.provides: CMakeFiles/singletest.dir/singletest.c.o.requires
	$(MAKE) -f CMakeFiles/singletest.dir/build.make CMakeFiles/singletest.dir/singletest.c.o.provides.build
.PHONY : CMakeFiles/singletest.dir/singletest.c.o.provides

CMakeFiles/singletest.dir/singletest.c.o.provides.build: CMakeFiles/singletest.dir/singletest.c.o

CMakeFiles/singletest.dir/24Layer.c.o: CMakeFiles/singletest.dir/flags.make
CMakeFiles/singletest.dir/24Layer.c.o: ../24Layer.c
	$(CMAKE_COMMAND) -E cmake_progress_report /home/binghao/cnn/24net/singletest/build/CMakeFiles $(CMAKE_PROGRESS_2)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building C object CMakeFiles/singletest.dir/24Layer.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -o CMakeFiles/singletest.dir/24Layer.c.o   -c /home/binghao/cnn/24net/singletest/24Layer.c

CMakeFiles/singletest.dir/24Layer.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/singletest.dir/24Layer.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -E /home/binghao/cnn/24net/singletest/24Layer.c > CMakeFiles/singletest.dir/24Layer.c.i

CMakeFiles/singletest.dir/24Layer.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/singletest.dir/24Layer.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -S /home/binghao/cnn/24net/singletest/24Layer.c -o CMakeFiles/singletest.dir/24Layer.c.s

CMakeFiles/singletest.dir/24Layer.c.o.requires:
.PHONY : CMakeFiles/singletest.dir/24Layer.c.o.requires

CMakeFiles/singletest.dir/24Layer.c.o.provides: CMakeFiles/singletest.dir/24Layer.c.o.requires
	$(MAKE) -f CMakeFiles/singletest.dir/build.make CMakeFiles/singletest.dir/24Layer.c.o.provides.build
.PHONY : CMakeFiles/singletest.dir/24Layer.c.o.provides

CMakeFiles/singletest.dir/24Layer.c.o.provides.build: CMakeFiles/singletest.dir/24Layer.c.o

# Object files for target singletest
singletest_OBJECTS = \
"CMakeFiles/singletest.dir/singletest.c.o" \
"CMakeFiles/singletest.dir/24Layer.c.o"

# External object files for target singletest
singletest_EXTERNAL_OBJECTS =

singletest: CMakeFiles/singletest.dir/singletest.c.o
singletest: CMakeFiles/singletest.dir/24Layer.c.o
singletest: CMakeFiles/singletest.dir/build.make
singletest: /usr/local/lib/libopencv_core.a
singletest: /usr/local/lib/libopencv_flann.a
singletest: /usr/local/lib/libopencv_imgproc.a
singletest: /usr/local/lib/libopencv_highgui.a
singletest: /usr/local/lib/libopencv_features2d.a
singletest: /usr/local/lib/libopencv_calib3d.a
singletest: /usr/local/lib/libopencv_ml.a
singletest: /usr/local/lib/libopencv_video.a
singletest: /usr/local/lib/libopencv_legacy.a
singletest: /usr/local/lib/libopencv_objdetect.a
singletest: /usr/local/lib/libopencv_photo.a
singletest: /usr/local/lib/libopencv_gpu.a
singletest: /usr/local/lib/libopencv_videostab.a
singletest: /usr/local/lib/libopencv_ts.a
singletest: /usr/local/lib/libopencv_ocl.a
singletest: /usr/local/lib/libopencv_superres.a
singletest: /usr/local/lib/libopencv_nonfree.a
singletest: /usr/local/lib/libopencv_stitching.a
singletest: /usr/local/lib/libopencv_contrib.a
singletest: /usr/local/lib/libopencv_nonfree.a
singletest: /usr/local/lib/libopencv_gpu.a
singletest: /usr/local/lib/libopencv_legacy.a
singletest: /usr/local/lib/libopencv_photo.a
singletest: /usr/local/lib/libopencv_ocl.a
singletest: /usr/local/lib/libopencv_calib3d.a
singletest: /usr/local/lib/libopencv_features2d.a
singletest: /usr/local/lib/libopencv_flann.a
singletest: /usr/local/lib/libopencv_ml.a
singletest: /usr/local/lib/libopencv_video.a
singletest: /usr/local/lib/libopencv_objdetect.a
singletest: /usr/local/lib/libopencv_highgui.a
singletest: /usr/local/lib/libopencv_imgproc.a
singletest: /usr/local/lib/libopencv_core.a
singletest: /usr/local/share/OpenCV/3rdparty/lib/liblibtiff.a
singletest: /usr/lib/x86_64-linux-gnu/libjpeg.so
singletest: /usr/lib/x86_64-linux-gnu/libpng.so
singletest: /usr/lib/x86_64-linux-gnu/libjasper.so
singletest: /usr/lib/x86_64-linux-gnu/libjpeg.so
singletest: /usr/lib/x86_64-linux-gnu/libpng.so
singletest: /usr/lib/x86_64-linux-gnu/libjasper.so
singletest: /usr/lib/x86_64-linux-gnu/libz.so
singletest: /usr/lib/x86_64-linux-gnu/libImath.so
singletest: /usr/lib/x86_64-linux-gnu/libIlmImf.so
singletest: /usr/lib/x86_64-linux-gnu/libIex.so
singletest: /usr/lib/x86_64-linux-gnu/libHalf.so
singletest: /usr/lib/x86_64-linux-gnu/libIlmThread.so
singletest: /usr/lib/x86_64-linux-gnu/libQtOpenGL.so
singletest: /usr/lib/x86_64-linux-gnu/libQtGui.so
singletest: /usr/lib/x86_64-linux-gnu/libQtTest.so
singletest: /usr/lib/x86_64-linux-gnu/libQtCore.so
singletest: /usr/lib/x86_64-linux-gnu/libbz2.so
singletest: /usr/lib/x86_64-linux-gnu/libGLU.so
singletest: /usr/lib/x86_64-linux-gnu/libGL.so
singletest: /usr/lib/x86_64-linux-gnu/libSM.so
singletest: /usr/lib/x86_64-linux-gnu/libICE.so
singletest: /usr/lib/x86_64-linux-gnu/libX11.so
singletest: /usr/lib/x86_64-linux-gnu/libXext.so
singletest: CMakeFiles/singletest.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking CXX executable singletest"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/singletest.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/singletest.dir/build: singletest
.PHONY : CMakeFiles/singletest.dir/build

CMakeFiles/singletest.dir/requires: CMakeFiles/singletest.dir/singletest.c.o.requires
CMakeFiles/singletest.dir/requires: CMakeFiles/singletest.dir/24Layer.c.o.requires
.PHONY : CMakeFiles/singletest.dir/requires

CMakeFiles/singletest.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/singletest.dir/cmake_clean.cmake
.PHONY : CMakeFiles/singletest.dir/clean

CMakeFiles/singletest.dir/depend:
	cd /home/binghao/cnn/24net/singletest/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/binghao/cnn/24net/singletest /home/binghao/cnn/24net/singletest /home/binghao/cnn/24net/singletest/build /home/binghao/cnn/24net/singletest/build /home/binghao/cnn/24net/singletest/build/CMakeFiles/singletest.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/singletest.dir/depend

