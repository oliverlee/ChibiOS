# List of the ChibiOS generic STM32F4xx startup and CMSIS files.
set(CHIBIOS_STARTUP_SRC
    ${CHIBIOS_ROOT_DIR}/common/ports/ARMCMx/compilers/GCC/crt1.c
    ${CHIBIOS_ROOT_DIR}/common/ports/ARMCMx/compilers/GCC/vectors.c
)

set(CHIBIOS_STARTUP_ASM
    ${CHIBIOS_ROOT_DIR}/common/ports/ARMCMx/compilers/GCC/crt0_v7m.s
)

set(CHIBIOS_STARTUP_INCLUDE_DIR
    ${CHIBIOS_ROOT_DIR}/common/ports/ARMCMx/compilers/GCC
    ${CHIBIOS_ROOT_DIR}/common/ports/ARMCMx/devices/STM32F4xx
    ${CHIBIOS_ROOT_DIR}/ext/CMSIS/include
    ${CHIBIOS_ROOT_DIR}/ext/CMSIS/ST/STM32F4xx
)

set(CHIBIOS_STARTUP_LINKER_DIR
    ${CHIBIOS_ROOT_DIR}/common/ports/ARMCMx/compilers/GCC/ld
)
