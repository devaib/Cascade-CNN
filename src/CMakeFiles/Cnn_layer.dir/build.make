# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.3

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


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
CMAKE_COMMAND = /usr/local/Cellar/cmake/3.3.1/bin/cmake

# The command to remove a file.
RM = /usr/local/Cellar/cmake/3.3.1/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/wbh/cnn/src

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/wbh/cnn/src

# Include any dependencies generated for this target.
include CMakeFiles/Cnn_layer.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/Cnn_layer.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/Cnn_layer.dir/flags.make

CMakeFiles/Cnn_layer.dir/Cnn_layer.c.o: CMakeFiles/Cnn_layer.dir/flags.make
CMakeFiles/Cnn_layer.dir/Cnn_layer.c.o: Cnn_layer.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/wbh/cnn/src/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object CMakeFiles/Cnn_layer.dir/Cnn_layer.c.o"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -o CMakeFiles/Cnn_layer.dir/Cnn_layer.c.o   -c /Users/wbh/cnn/src/Cnn_layer.c

CMakeFiles/Cnn_layer.dir/Cnn_layer.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/Cnn_layer.dir/Cnn_layer.c.i"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -E /Users/wbh/cnn/src/Cnn_layer.c > CMakeFiles/Cnn_layer.dir/Cnn_layer.c.i

CMakeFiles/Cnn_layer.dir/Cnn_layer.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/Cnn_layer.dir/Cnn_layer.c.s"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -S /Users/wbh/cnn/src/Cnn_layer.c -o CMakeFiles/Cnn_layer.dir/Cnn_layer.c.s

CMakeFiles/Cnn_layer.dir/Cnn_layer.c.o.requires:

.PHONY : CMakeFiles/Cnn_layer.dir/Cnn_layer.c.o.requires

CMakeFiles/Cnn_layer.dir/Cnn_layer.c.o.provides: CMakeFiles/Cnn_layer.dir/Cnn_layer.c.o.requires
	$(MAKE) -f CMakeFiles/Cnn_layer.dir/build.make CMakeFiles/Cnn_layer.dir/Cnn_layer.c.o.provides.build
.PHONY : CMakeFiles/Cnn_layer.dir/Cnn_layer.c.o.provides

CMakeFiles/Cnn_layer.dir/Cnn_layer.c.o.provides.build: CMakeFiles/Cnn_layer.dir/Cnn_layer.c.o


# Object files for target Cnn_layer
Cnn_layer_OBJECTS = \
"CMakeFiles/Cnn_layer.dir/Cnn_layer.c.o"

# External object files for target Cnn_layer
Cnn_layer_EXTERNAL_OBJECTS =

Cnn_layer: CMakeFiles/Cnn_layer.dir/Cnn_layer.c.o
Cnn_layer: CMakeFiles/Cnn_layer.dir/build.make
Cnn_layer: /usr/local/lib/libopencv_videostab.3.0.0.dylib
Cnn_layer: /usr/local/lib/libopencv_ts.a
Cnn_layer: /usr/local/lib/libopencv_superres.3.0.0.dylib
Cnn_layer: /usr/local/lib/libopencv_stitching.3.0.0.dylib
Cnn_layer: /usr/local/lib/libopencv_shape.3.0.0.dylib
Cnn_layer: /usr/local/lib/libopencv_photo.3.0.0.dylib
Cnn_layer: /usr/local/lib/libopencv_objdetect.3.0.0.dylib
Cnn_layer: /usr/local/lib/libopencv_calib3d.3.0.0.dylib
Cnn_layer: /usr/local/share/OpenCV/3rdparty/lib/libippicv.a
Cnn_layer: /usr/local/lib/libopencv_features2d.3.0.0.dylib
Cnn_layer: /usr/local/lib/libopencv_ml.3.0.0.dylib
Cnn_layer: /usr/local/lib/libopencv_highgui.3.0.0.dylib
Cnn_layer: /usr/local/lib/libopencv_videoio.3.0.0.dylib
Cnn_layer: /usr/local/lib/libopencv_imgcodecs.3.0.0.dylib
Cnn_layer: /usr/local/lib/libopencv_flann.3.0.0.dylib
Cnn_layer: /usr/local/lib/libopencv_video.3.0.0.dylib
Cnn_layer: /usr/local/lib/libopencv_imgproc.3.0.0.dylib
Cnn_layer: /usr/local/lib/libopencv_core.3.0.0.dylib
Cnn_layer: CMakeFiles/Cnn_layer.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/wbh/cnn/src/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable Cnn_layer"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/Cnn_layer.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/Cnn_layer.dir/build: Cnn_layer

.PHONY : CMakeFiles/Cnn_layer.dir/build

CMakeFiles/Cnn_layer.dir/requires: CMakeFiles/Cnn_layer.dir/Cnn_layer.c.o.requires

.PHONY : CMakeFiles/Cnn_layer.dir/requires

CMakeFiles/Cnn_layer.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/Cnn_layer.dir/cmake_clean.cmake
.PHONY : CMakeFiles/Cnn_layer.dir/clean

CMakeFiles/Cnn_layer.dir/depend:
	cd /Users/wbh/cnn/src && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/wbh/cnn/src /Users/wbh/cnn/src /Users/wbh/cnn/src /Users/wbh/cnn/src /Users/wbh/cnn/src/CMakeFiles/Cnn_layer.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/Cnn_layer.dir/depend

