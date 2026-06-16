# Automatically find all C files in this directory
# CONFIGURE_DEPENDS tells the build system to re-run CMake if a new file is added here
file(GLOB ACCEL_SOURCES CONFIGURE_DEPENDS "*.c")

# Add them all to the app target
target_sources(app PRIVATE ${ACCEL_SOURCES})

# For accel_registry.h
target_include_directories(app PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})