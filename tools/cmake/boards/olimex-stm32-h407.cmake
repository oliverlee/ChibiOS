# Olimex STM32-H407 board

# platform files and flags
include(${CHIBIOS_CMAKE_DIR}/platforms/stm32-f4xx.cmake)
include(${CHIBIOS_CMAKE_DIR}/ports/gcc/stm32-f40x.cmake)

# path to the board files
set(CHIBIOS_BOARD_PATH "${CHIBIOS_ROOT}/boards/OLIMEX_STM32_H407")
