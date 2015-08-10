get_filename_component(CHIBIOS_HAL_DIR
    ${CMAKE_CURRENT_LIST_FILE} DIRECTORY)

set(CHIBIOS_HAL_INCLUDE_DIR
    ${CHIBIOS_HAL_DIR}/include)

set(CHIBIOS_HAL_SRC
    ${CHIBIOS_HAL_DIR}/src/hal.c
    ${CHIBIOS_HAL_DIR}/src/hal_queues.c
    ${CHIBIOS_HAL_DIR}/src/hal_mmcsd.c
    ${CHIBIOS_HAL_DIR}/src/adc.c
    ${CHIBIOS_HAL_DIR}/src/can.c
    ${CHIBIOS_HAL_DIR}/src/dac.c
    ${CHIBIOS_HAL_DIR}/src/ext.c
    ${CHIBIOS_HAL_DIR}/src/gpt.c
    ${CHIBIOS_HAL_DIR}/src/i2c.c
    ${CHIBIOS_HAL_DIR}/src/i2s.c
    ${CHIBIOS_HAL_DIR}/src/icu.c
    ${CHIBIOS_HAL_DIR}/src/mac.c
    ${CHIBIOS_HAL_DIR}/src/mmc_spi.c
    ${CHIBIOS_HAL_DIR}/src/pal.c
    ${CHIBIOS_HAL_DIR}/src/pwm.c
    ${CHIBIOS_HAL_DIR}/src/rtc.c
    ${CHIBIOS_HAL_DIR}/src/sdc.c
    ${CHIBIOS_HAL_DIR}/src/serial.c
    ${CHIBIOS_HAL_DIR}/src/serial_usb.c
    ${CHIBIOS_HAL_DIR}/src/spi.c
    ${CHIBIOS_HAL_DIR}/src/st.c
    ${CHIBIOS_HAL_DIR}/src/uart.c
    ${CHIBIOS_HAL_DIR}/src/usb.c
)
