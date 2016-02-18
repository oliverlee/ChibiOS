# List of the ChibiOS/RT ARMv7M generic port files.
set(CHIBIOS_PORT_SRC
    ${CHIBIOS_ROOT_DIR}/rt/ports/ARMCMx/chcore.c
    ${CHIBIOS_ROOT_DIR}/rt/ports/ARMCMx/chcore_v7m.c
)

set(CHIBIOS_PORT_ASM
    ${CHIBIOS_ROOT_DIR}/rt/ports/ARMCMx/compilers/GCC/chcoreasm_v7m.s
)

set(CHIBIOS_PORT_INCLUDE_DIR
    ${CHIBIOS_ROOT_DIR}/rt/ports/ARMCMx
    ${CHIBIOS_ROOT_DIR}/rt/ports/ARMCMx/compilers/GCC
)
