project(CHIBIOS-DEMOS-RT-STM32F746G-DISCOVERY)

cmake_minimum_required(VERSION 3.0)

set(CHIBIOS_BOARD_CMAKE_FILE
    ../../../os/hal/boards/ST_STM32F746G_DISCOVERY/board.cmake)
include(../../../chibios.cmake)

include_directories(${CMAKE_CURRENT_SOURCE_DIR})
add_chibios_executable(ch chconf.h halconf.h mcuconf.h main.c)
