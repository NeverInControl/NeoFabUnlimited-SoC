cmake_minimum_required(VERSION 3.20.0)
find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})
project(fpga_manager)

# Add include paths globally
target_include_directories(app PRIVATE include)

# Add cuustom driver functions globally
target_include_directories(app PRIVATE drivers/fpga)

# Add hardware driver
# add_subdirectory(drivers/fpga)

# Add accelerator manager
add_subdirectory(lib/accel_manager)

# Add accelerators
add_subdirectory(accels)

# Compile both main.c and driver directly into the app
target_sources(app PRIVATE 
    src/main.c 
    drivers/fpga/fabulous_driver.c
)