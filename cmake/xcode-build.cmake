cmake_minimum_required(VERSION 3.13)

# ConfigureXcodeBuildCommand prepares an `xcodebuild` shell invocation
# to run the build.  BUILD_MODE should be something like "Release" or
# "Debug".  This macro supports an optional SDK parameter string.
#
# To use XCODE_BUILD_CMD, pass it as an argument to ExternalProject_add.
# See: https://cmake.org/cmake/help/latest/module/ExternalProject.html
#
# After this macro is invoked, the variables "XCODE_BUILD_CMD",
# "OBJ_ROOT", and "SYM_ROOT" are set.
#
# After the build is completed, the resulting binaries will be symlinked
# from the ${OBJ_ROOT} build path into ${SYM_ROOT}/artifacts.
macro(ConfigureXcodeBuildCommand
  BUILD_MODE
  BUILD_DIR
  PROJECT
  SCHEME
)
  # Generate the build command.  It will be appended to.
  set(XCODE_BUILD_CMD
    xcodebuild
    -quiet
    -project ${PROJECT}
    -scheme ${SCHEME}
    -configuration ${BUILD_MODE}
  )

  set(OBJ_ROOT ${BUILD_DIR}/obj)
  set(SYM_ROOT ${BUILD_DIR}/artifacts)

  # Configure external build for custom SDK if necessary.
  if(${ARGC} GREATER 5)
    message("Building with -sdk ${ARGV5}")
    set(XCODE_BUILD_CMD ${XCODE_BUILD_CMD} -sdk ${ARGV5})
    set(OBJ_ROOT ${BUILD_DIR}/${ARGV5}/obj)
    set(SYM_ROOT ${BUILD_DIR}/${ARGV5}/artifacts)
  endif()

  # Append OBJROOT for intermediate objects and SYMROOT for symlinked
  # final products.
  set(XCODE_BUILD_CMD
    ${XCODE_BUILD_CMD}
    OBJROOT=${OBJ_ROOT}
    SYMROOT=${SYM_ROOT}
  )
endmacro()
