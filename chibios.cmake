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
    message("Using CMAKE BOARD FILE: ${CHIBIOS_BOARD_CMAKE_FILE}")
else(EXISTS "${CHIBIOS_BOARD_CMAKE_FILE}")
    message(SEND_ERROR
        "The CHIBIOS_BOARD_CMAKE_FILE variable must be set to a valid file.")
endif(EXISTS "${CHIBIOS_BOARD_CMAKE_FILE}")

## Build global options
message("Clearing previous settings in compile and link flags...")
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
set_property(CACHE CHIBIOS_USE_FPU PROPERTY STRINGS no soft softfp hard)
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
set(CMAKE_C_FLAGS_DEBUG "-gdwarf-4 -fvar-tracking-assignments -O0" CACHE
    STRING "Flags used by the compiler during debug builds." FORCE)
set(CMAKE_CXX_FLAGS_DEBUG "-gdwarf-4 -fvar-tracking-assignments -O0" CACHE
    STRING "Flags used by the compiler during debug builds." FORCE)
set(CMAKE_C_FLAGS_RELEASE "-Os -DNDEBUG" CACHE
    STRING "Flags used by the compiler during release builds." FORCE)
set(CMAKE_CXX_FLAGS_RELEASE "-Os -DNDEBUG" CACHE
    STRING "Flags used by the compiler during release builds." FORCE)
set(CMAKE_C_FLAGS_RELWITHDEBINFO "-gdwarf-4 -fvar-tracking-assignments -Os -DNDEBUG" CACHE
    STRING "Flags used by the compiler during release builds." FORCE)
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-gdwarf-4 -fvar-tracking-assignments -Os -DNDEBUG" CACHE
    STRING "Flags used by the compiler during release builds." FORCE)

# set default build type to Debug
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Debug" CACHE STRING
        "Choose the type of build, options are: Debug, Release, RelWithDebInfo."
        FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS Debug Release RelWithDebInfo)
endif()
message(STATUS "CMAKE_BUILD_TYPE set to ${CMAKE_BUILD_TYPE}.")

## OpenOCD post-build, flashing option
option(OPENOCD_FLASH_TARGET "Flash target to board after build." OFF)
option(OPENOCD_FLASH_AND_RUN_TARGET "Flash target to board and run after build." OFF)
if(OPENOCD_FLASH_TARGET OR OPENOCD_FLASH_AND_RUN_TARGET)
    include(${CMAKE_CURRENT_LIST_DIR}/openocd.cmake)
endif()

## Include common HAL sources
include(${CHIBIOS_ROOT_DIR}/hal/hal.cmake)
include(${CHIBIOS_ROOT_DIR}/hal/osal/rt/osal.cmake)
# Include streams sources
include(${CHIBIOS_ROOT_DIR}/hal/lib/streams/streams.cmake)
# Include various sources
include(${CHIBIOS_ROOT_DIR}/various/various.cmake)
# Include FATFS sources
set(CHIBIOS_BUILD_WITH_FATFS OFF) # set this ON in binary specific CMakeLists.txt if needed
include(${CHIBIOS_VARIOUS_DIR}/fatfs_bindings/fatfs.cmake)

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
    ${CHIBIOS_STREAMS_INCLUDE_DIR}
    ${CHIBIOS_VARIOUS_INCLUDE_DIR}
    ${CHIBIOS_FATFS_INCLUDE_DIR}
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
        "${OPT_FLAGS} -ffunction-sections -fdata-sections -fno-common -fno-builtin")
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
    "${MC_FLAGS} ${OPT_FLAGS} -nostartfiles --specs=nano.specs --specs=nosys.specs ${LD_FLAGS}")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} \
-Wl,--no-warn-mismatch,--library-path=${CHIBIOS_RULES_PATH},--script=${CHIBIOS_LINKER_SCRIPT}")

# ChibiOS build output options
option(CHIBIOS_CREATE_BIN "Create executable binary file." FALSE)
option(CHIBIOS_CREATE_DUMP "Create executable dump file." FALSE)
option(CHIBIOS_CREATE_HEX "Create executable Intel HEX file." FALSE)
option(CHIBIOS_CREATE_LIST "Create executable list file." FALSE)
option(CHIBIOS_CREATE_MAP "Create executable map file." FALSE)
mark_as_advanced(CHIBIOS_CREATE_BIN CHIBIOS_CREATE_DUMP CHIBIOS_CREATE_HEX CHIBIOS_CREATE_LIST CHIBIOS_CREATE_MAP)

## Define macro for executable
macro(add_chibios_executable target_name)

    set(CHIBIOS_CPP_WRAPPERS_SRC)
    foreach(src in ${ARGN})
        get_filename_component(src_ext ${src} EXT)
        if( (src_ext STREQUAL ".cc") OR
            (src_ext STREQUAL ".cpp") OR
            (src_ext STREQUAL ".cxx") )
            set(CHIBIOS_CPP_WRAPPERS_SRC ${CHIBIOS_VARIOUS_DIR}/cpp_wrappers/syscalls_cpp.cpp)
            break()
        endif()
    endforeach()

    if(CHIBIOS_BUILD_WITH_FATFS)
        set(CHIBIOS_USE_FATFS_SRC ${CHIBIOS_FATFS_SRC})
    else()
        set(CHIBIOS_USE_FATFS_SRC)
    endif()

    add_executable(${target_name}
        ${CHIBIOS_HAL_SRC} ${CHIBIOS_OSAL_SRC} ${CHIBIOS_RT_SRC} ${CHIBIOS_TEST_SRC}
        ${CHIBIOS_BOARD_SRC} ${CHIBIOS_PLATFORM_SRC} ${CHIBIOS_PORT_SRC} ${CHIBIOS_STARTUP_SRC}
        ${CHIBIOS_PORT_ASM} ${CHIBIOS_STARTUP_ASM} ${CHIBIOS_STREAMS_SRC} ${CHIBIOS_VARIOUS_SRC}
        ${CHIBIOS_USE_FATFS_SRC} ${CHIBIOS_CPP_WRAPPERS_SRC} ${ARGN}
    )

    # Extract FATFS archive
    add_custom_command(
        OUTPUT ${CHIBIOS_ROOT_DIR}/../ext/fatfs/src/ff.c ${CHIBIOS_ROOT_DIR}/../ext/fatfs/src/option/unicode.c
        COMMAND ${CMAKE_COMMAND} -E tar xf ${CHIBIOS_ROOT_DIR}/../ext/fatfs-0.10b-patched.7z
        WORKING_DIRECTORY ${CHIBIOS_ROOT_DIR}/../ext
        COMMENT "Extracting FATFS module in ChibiOS"
    )

    set_target_properties(${target_name} PROPERTIES SUFFIX ".elf")
    set(target_path ${CMAKE_CURRENT_BINARY_DIR}/${target_name}.elf)

    # Create map file
    if(CHIBIOS_CREATE_MAP)
        set_property(TARGET ${target_name} APPEND_STRING PROPERTY
            LINK_FLAGS " -Wl,-Map=${target_name}.map,--cref"
        )
    endif()

    # Create Intel HEX file
    if(CHIBIOS_CREATE_HEX)
        add_custom_command(TARGET ${target_name} POST_BUILD
            COMMAND ${CMAKE_OBJCOPY} -O ihex ${target_path} ${target_name}.hex
            COMMENT "Creating ${target_name}.hex"
        )
    endif()

    # Create binary file
    if(CHIBIOS_CREATE_BIN)
        add_custom_command(TARGET ${target_name} POST_BUILD
            COMMAND ${CMAKE_OBJCOPY} -O binary ${target_path} ${target_name}.bin
            COMMENT "Creating ${target_name}.bin"
        )
    endif()

    # Create dump file
    if(CHIBIOS_CREATE_DUMP)
        add_custom_command(TARGET ${target_name} POST_BUILD
            COMMAND ${CMAKE_OBJDUMP} -x --syms ${target_path} > ${target_name}.dmp
            COMMENT "Creating ${target_name}.dmp"
        )
    endif()

    # Create list file
    if(CHIBIOS_CREATE_LIST)
        add_custom_command(TARGET ${target_name} POST_BUILD
            COMMAND ${CMAKE_OBJDUMP} -S ${target_path} > ${target_name}.list
            COMMENT "Creating ${target_name}.list"
        )
    endif()

    set_directory_properties(PROPERTIES ADDITIONAL_MAKE_CLEAN_FILES
        "${target_name}.map;${target_name}.hex;${target_name}.bin;${target_name}.dmp;${target_name}.list"
    )

    # Flash (and run) target
    if((NOT OPENOCD_INTERFACE_CFG) AND (NOT OPENOCD_TARGET_CFG))
        message(WARNING "No OpenOCD configuration set. Skipping flash command.")
    else()
        if(OPENOCD_FLASH_AND_RUN_TARGET)
            add_flash_and_run_target(${target_name})
        elseif(OPENOCD_FLASH_TARGET)
            add_flash_target(${target_name})
        endif()
    endif()
endmacro(add_chibios_executable target_name)

## Define macro for ChibiOS debug options
macro(chibios_debug_option variable description)
    option(CHIBIOS_DBG_${variable} ${description} FALSE)
    if(CHIBIOS_DBG_${variable})
        add_definitions("-DCH_DBG_${variable}=1")
    else()
        add_definitions("-DCH_DBG_${variable}=0")
    endif()
endmacro()
chibios_debug_option(STATISTICS "Enable kernel statistics.")
chibios_debug_option(SYSTEM_STATE_CHECK "Enable kernel system state check.")
chibios_debug_option(ENABLE_CHECKS "Enable API parameter check.")
chibios_debug_option(ENABLE_ASSERTS "Enable kernel assertions.")
chibios_debug_option(ENABLE_TRACE "Enable context switch trace buffer.")
chibios_debug_option(ENABLE_STACK_CHECK "Enable runtime thread stack check. Not enabled for all ports.")
chibios_debug_option(FILL_THREADS "Enable thtread stack initialization.")
chibios_debug_option(THREADS_PROFILING "Enable thread profiling. Not compatible with tickless mode.")