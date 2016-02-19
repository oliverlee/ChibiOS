cmake_minimum_required(VERSION 3.0)
enable_language(CXX C ASM)

## Define ChibiOS version
set(CHIBIOS_VERSION_MAJOR 16)
set(CHIBIOS_VERSION_MINOR 1)
set(CHIBIOS_VERSION_PATCH 0)
set(CHIBIOS_VERSION
    ${CHIBIOS_VERSION_MAJOR} ${CHIBIOS_VERSION_MINOR} ${CHIBIOS_VERSION_PATCH})

get_filename_component(CHIBIOS_ROOT_DIR ${CMAKE_CURRENT_LIST_FILE} DIRECTORY)
set(CHIBIOS_ROOT_DIR ${CHIBIOS_ROOT_DIR}/os)

# Set linker library rules path
set(CHIBIOS_RULES_PATH ${CHIBIOS_ROOT_DIR}/common/ports/ARMCMx/compilers/GCC)

## Clear compiler and linker flags
set(CMAKE_C_FLAGS)
set(CMAKE_CXX_FLAGS)
set(CMAKE_EXE_LINKER_FLAGS)

## Define cross-compiler
if(NOT CMAKE_TOOLCHAIN_FILE)
    message(FATAL_ERROR
        "CMAKE_TOOLCHAIN_FILE must be defined when building the ChibiOS library.")
    if(NOT TOOLCHAIN_BIN_DIR)
        message(FATAL_ERROR
            "Please specify TOOLCHAIN_BIN_DIR in CMAKE_TOOLCHAIN_FILE.")
    endif(NOT TOOLCHAIN_BIN_DIR)
    if(NOT TOOLCHAIN_COMMON_PREFIX)
        message(FATAL_ERROR
            "Please specify TOOLCHAIN_COMMON_PREFIX in CMAKE_TOOLCHAIN_FILE.")
    endif(NOT TOOLCHAIN_COMMON_PREFIX)
endif(NOT CMAKE_TOOLCHAIN_FILE)
set(CMAKE_OBJCOPY ${TOOLCHAIN_BIN_DIR}/${TOOLCHAIN_COMMON_PREFIX}-objcopy)
set(CMAKE_OBJDUMP ${TOOLCHAIN_BIN_DIR}/${TOOLCHAIN_COMMON_PREFIX}-objdump)
set(CMAKE_ASM_COMPILER ${TOOLCHAIN_BIN_DIR}/${TOOLCHAIN_COMMON_PREFIX}-gcc)

## Select ChibiOS board file for board and platform settings
if(NOT CHIBIOS_BOARD_CMAKE_FILE)
    set(CHIBIOS_BOARD_CMAKE_FILE "" CACHE FILEPATH "ChibiOS Board CMake file.")
endif(NOT CHIBIOS_BOARD_CMAKE_FILE)
get_filename_component(CHIBIOS_BOARD_CMAKE_FILE ${CHIBIOS_BOARD_CMAKE_FILE} ABSOLUTE)
if(EXISTS "${CHIBIOS_BOARD_CMAKE_FILE}")
    message("Using settings from ${CHIBIOS_BOARD_CMAKE_FILE}")
else(EXISTS "${CHIBIOS_BOARD_CMAKE_FILE}")
    message(FATAL_ERROR
        "The CHIBIOS_BOARD_CMAKE_FILE variable must be set to a valid file.")
endif(EXISTS "${CHIBIOS_BOARD_CMAKE_FILE}")

## Build global options
# Compiler options here.
set(OPT_FLAGS "-fomit-frame-pointer -falign-functions=16")
# C specific options
set(C_FLAGS "")
# C++ specific options
set(CXX_FLAGS "-fno-rtti")
# Assembler options
set(ASM_FLAGS "")
# Linker options
set(LD_FLAGS "")

## ChibiOS build options
option(CHIBIOS_USE_LINK_GC "Remove unused code and data when linking." TRUE)
option(CHIBIOS_USE_THUMB "Compile application in THUMB mode." TRUE)
option(CHIBIOS_USE_LTO "Perform Link Time Optimization." TRUE)
set(CHIBIOS_USE_FPU "hard"
    CACHE STRING "Enables use of FPU if supported (no, soft, softfp, hard).")
set(CHIBIOS_USE_PROCESS_STACKSIZE "0x400"
    CACHE STRING "Stack size used by the main() thread.")
set(CHIBIOS_USE_EXCEPTION_STACKSIZE "0x400"
    CACHE STRING "Stack size used for processing interrupts and exceptions.")

## Compiler settings
# Define C warning options
set(C_WARN_FLAGS "-Wall -Wextra -Wundef -Wstrict-prototypes")
# Define C++ warning options
set(CXX_WARN_FLAGS "-Wall -Wextra -Wundef")

## Debug/Release flags. User should not should not override.
# Release uses MINRELSIZE
set(CMAKE_C_FLAGS_DEBUG "-ggdb3 -O0" CACHE
    STRING "Flags used by the compiler during debug builds." FORCE)
set(CMAKE_CXX_FLAGS_DEBUG "-ggdb3 -O0" CACHE
    STRING "Flags used by the compiler during debug builds." FORCE)
set(CMAKE_C_FLAGS_RELEASE "-Os -DNDEBUG" CACHE
    STRING "Flags used by the compiler during release builds." FORCE)
set(CMAKE_CXX_FLAGS_RELEASE "-Os -DNDEBUG" CACHE
    STRING "Flags used by the compiler during release builds." FORCE)

# set default build type to Debug
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Debug" CACHE
        STRING "Choose the type of build, options are: Debug, Release." FORCE)
    message("CMAKE_BUILD_TYPE not set. Using ${CMAKE_BUILD_TYPE}.")
endif()

## Include common HAL sources
include(${CHIBIOS_ROOT_DIR}/hal/hal.cmake)
include(${CHIBIOS_ROOT_DIR}/hal/osal/rt/osal.cmake)

## Include common RT sources
include(${CHIBIOS_ROOT_DIR}/rt/rt.cmake)
include(${CHIBIOS_ROOT_DIR}/../test/rt/test.cmake)

## Include board/platform specific files
include(${CHIBIOS_BOARD_CMAKE_FILE})

set(CHIBIOS_INCLUDE_DIR
    # common RTOS include directories
    ${CHIBIOS_HAL_INCLUDE_DIR}
    ${CHIBIOS_OSAL_INCLUDE_DIR}
    ${CHIBIOS_RT_INCLUDE_DIR}
    ${CHIBIOS_TEST_INCLUDE_DIR}
    ${CHIBIOS_ROOT_DIR}/various
    # board specific include directories
    ${CHIBIOS_BOARD_INCLUDE_DIR}
    ${CHIBIOS_PLATFORM_INCLUDE_DIR}
    ${CHIBIOS_PORT_INCLUDE_DIR}
    ${CHIBIOS_STARTUP_INCLUDE_DIR}
)
include_directories(${CHIBIOS_INCLUDE_DIR})

## Handle ChibiOS CMake build options
# Disable interworking between ARM and THUMB
set(C_FLAGS "${C_FLAGS} -mno-thumb-interwork")
set(CXX_FLAGS "${CXX_FLAGS} -mno-thumb-interwork")
set(ASM_FLAGS "${ASM_FLAGS} -mno-thumb-interwork")
set(LD_FLAGS "${LD_FLAGS} -mno-thumb-interwork")
# Pure THUMB mode, THUMB C code cannot be called by ARM asm code directly.
if(CHIBIOS_USE_THUMB)
    add_definitions("-DTHUMB -DTHUMB_PRESENT -DTHUMB_NO_INTERWORKING")
    set(C_FLAGS "${C_FLAGS} -mthumb")
    set(CXX_FLAGS "${CXX_FLAGS} -mthumb")
    set(ASM_FLAGS "${ASM_FLAGS} -mthumb")
    set(LD_FLAGS "${LD_FLAGS} -mthumb")
endif(CHIBIOS_USE_THUMB)

if(CHIBIOS_USE_LINK_GC)
    set(OPT_FLAGS
        "${OPT_FLAGS} -ffunction-sections -fdata-sections -fno-common")
    set(LD_FLAGS "${LD_FLAGS} -Wl,--gc-sections")
endif(CHIBIOS_USE_LINK_GC)

if(CHIBIOS_USE_LTO)
    set(OPT_FLAGS "${OPT_FLAGS} -flto")
endif(CHIBIOS_USE_LTO)

# Enables the use of FPU on Cortex-M4 (no, softfp, hard).
if( (CHIBIOS_USE_FPU STREQUAL "soft") OR
    (CHIBIOS_USE_FPU STREQUAL "softfp") OR
    (CHIBIOS_USE_FPU STREQUAL "hard"))
    set(OPT_FLAGS "${OPT_FLAGS} -mfloat-abi=${CHIBIOS_USE_FPU} -mfpu=fpv4-sp-d16 -fsingle-precision-constant")
    add_definitions("-DCORTEX_USE_FPU=TRUE")
else()
    add_definitions("-DCORTEX_USE_FPU=FALSE")
endif()

set(LD_FLAGS "${LD_FLAGS} -Wl,--defsym=__process_stack_size__=${CHIBIOS_USE_PROCESS_STACKSIZE}")
set(LD_FLAGS "${LD_FLAGS},--defsym=__main_stack_size__=${CHIBIOS_USE_EXCEPTION_STACKSIZE}")

## Define compilation and linking flags
set(MC_FLAGS "-mcpu=${MCU}")
set(CMAKE_ASM_FLAGS "-x assembler-with-cpp ${MC_FLAGS} ${ASM_FLAGS}")
set(CMAKE_C_FLAGS "${MC_FLAGS} ${OPT_FLAGS} ${C_FLAGS} ${C_WARN_FLAGS}")
set(CMAKE_CXX_FLAGS "${MC_FLAGS} ${OPT_FLAGS} ${CXX_FLAGS} ${CXX_WARN_FLAGS}")
set(CMAKE_EXE_LINKER_FLAGS
    "${MC_FLAGS} ${OPT_FLAGS} -nostartfiles -Wl,--no-warn-mismatch,--library-path=${CHIBIOS_RULES_PATH},--script=${CHIBIOS_LINKER_SCRIPT} ${LD_FLAGS}")

## Define macro for executable
macro(add_chibios_executable target_name)
    add_executable(${target_name}
        ${CHIBIOS_HAL_SRC} ${CHIBIOS_OSAL_SRC} ${CHIBIOS_RT_SRC} ${CHIBIOS_TEST_SRC}
        ${CHIBIOS_BOARD_SRC} ${CHIBIOS_PLATFORM_SRC} ${CHIBIOS_PORT_SRC} ${CHIBIOS_STARTUP_SRC}
        ${CHIBIOS_PORT_ASM} ${CHIBIOS_STARTUP_ASM}
        ${ARGN}
    )
    set_target_properties(${target_name} PROPERTIES SUFFIX ".elf")
    set(target_path ${CMAKE_CURRENT_BINARY_DIR}/${target_name}.elf)

    # Output map file
    set_property(TARGET ${target_name} APPEND_STRING PROPERTY
        LINK_FLAGS " -Wl,-Map=${target_name}.map,--cref"
    )

    # Create Intel HEX file
    add_custom_command(TARGET ${target_name} POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} -O ihex ${target_path} ${target_name}.hex
        COMMENT "Creating ${target_name}.hex"
    )

    # Create binary file
    add_custom_command(TARGET ${target_name} POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} -O binary ${target_path} ${target_name}.bin
        COMMENT "Creating ${target_name}.bin"
    )

    # Create dump file
    add_custom_command(TARGET ${target_name} POST_BUILD
        COMMAND ${CMAKE_OBJDUMP} -x --syms ${target_path} > ${target_name}.dmp
        COMMENT "Creating ${target_name}.dmp"
    )

    # Create list file
    add_custom_command(TARGET ${target_name} POST_BUILD
        COMMAND ${CMAKE_OBJDUMP} -S ${target_path} > ${target_name}.list
        COMMENT "Creating ${target_name}.list"
    )

    set_directory_properties(PROPERTIES ADDITIONAL_MAKE_CLEAN_FILES
        "${target_name}.map;${target_name}.hex;${target_name}.bin;${target_name}.dmp;${target_name}.list"
    )
endmacro(add_chibios_executable target_name)
