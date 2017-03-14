# Define platform MCU
set(MCU cortex-m4)

# List of all the STM32F7xx platform files.
set(CHIBIOS_PLATFORM_SRC
    ${CHIBIOS_HAL_DIR}/ports/common/ARMCMx/nvic.c
    ${CHIBIOS_HAL_DIR}/ports/STM32/STM32F4xx/hal_lld.c
    ${CHIBIOS_HAL_DIR}/ports/STM32/STM32F4xx/ext_lld_isr.c
    ${CHIBIOS_HAL_DIR}/ports/STM32/LLD/ADCv2/adc_lld.c
    ${CHIBIOS_HAL_DIR}/ports/STM32/LLD/CANv1/can_lld.c
    ${CHIBIOS_HAL_DIR}/ports/STM32/LLD/EXTIv1/ext_lld.c
    ${CHIBIOS_HAL_DIR}/ports/STM32/LLD/DACv1/dac_lld.c
    ${CHIBIOS_HAL_DIR}/ports/STM32/LLD/DMAv2/stm32_dma.c
    ${CHIBIOS_HAL_DIR}/ports/STM32/LLD/GPIOv2/pal_lld.c
    ${CHIBIOS_HAL_DIR}/ports/STM32/LLD/I2Cv1/i2c_lld.c
    ${CHIBIOS_HAL_DIR}/ports/STM32/LLD/MACv1/mac_lld.c
    ${CHIBIOS_HAL_DIR}/ports/STM32/LLD/OTGv1/usb_lld.c
    ${CHIBIOS_HAL_DIR}/ports/STM32/LLD/RTCv2/rtc_lld.c
    ${CHIBIOS_HAL_DIR}/ports/STM32/LLD/SDIOv1/sdc_lld.c
    ${CHIBIOS_HAL_DIR}/ports/STM32/LLD/SPIv1/i2s_lld.c
    ${CHIBIOS_HAL_DIR}/ports/STM32/LLD/SPIv1/spi_lld.c
    ${CHIBIOS_HAL_DIR}/ports/STM32/LLD/TIMv1/gpt_lld.c
    ${CHIBIOS_HAL_DIR}/ports/STM32/LLD/TIMv1/icu_lld.c
    ${CHIBIOS_HAL_DIR}/ports/STM32/LLD/TIMv1/pwm_lld.c
    ${CHIBIOS_HAL_DIR}/ports/STM32/LLD/TIMv1/st_lld.c
    ${CHIBIOS_HAL_DIR}/ports/STM32/LLD/USARTv1/serial_lld.c
    ${CHIBIOS_HAL_DIR}/ports/STM32/LLD/USARTv1/uart_lld.c
    ${CHIBIOS_HAL_DIR}/ports/STM32/LLD/xWDGv1/wdg_lld.c
)

# Required include directories
set(CHIBIOS_PLATFORM_INCLUDE_DIR
    ${CHIBIOS_HAL_DIR}/ports/common/ARMCMx
    ${CHIBIOS_HAL_DIR}/ports/STM32/STM32F4xx
    ${CHIBIOS_HAL_DIR}/ports/STM32/LLD/ADCv2
    ${CHIBIOS_HAL_DIR}/ports/STM32/LLD/CANv1
    ${CHIBIOS_HAL_DIR}/ports/STM32/LLD/DACv1
    ${CHIBIOS_HAL_DIR}/ports/STM32/LLD/DMAv2
    ${CHIBIOS_HAL_DIR}/ports/STM32/LLD/EXTIv1
    ${CHIBIOS_HAL_DIR}/ports/STM32/LLD/GPIOv2
    ${CHIBIOS_HAL_DIR}/ports/STM32/LLD/I2Cv1
    ${CHIBIOS_HAL_DIR}/ports/STM32/LLD/MACv1
    ${CHIBIOS_HAL_DIR}/ports/STM32/LLD/OTGv1
    ${CHIBIOS_HAL_DIR}/ports/STM32/LLD/RTCv2
    ${CHIBIOS_HAL_DIR}/ports/STM32/LLD/SDIOv1
    ${CHIBIOS_HAL_DIR}/ports/STM32/LLD/SPIv1
    ${CHIBIOS_HAL_DIR}/ports/STM32/LLD/TIMv1
    ${CHIBIOS_HAL_DIR}/ports/STM32/LLD/USARTv1
    ${CHIBIOS_HAL_DIR}/ports/STM32/LLD/xWDGv1
)

# Include ARMv7m port files.
include(${CHIBIOS_ROOT_DIR}/rt/ports/ARMCMx/compilers/GCC/mk/port_v7m.cmake)

# Include STM32F4xx startup and CMSIS files.
include(${CHIBIOS_ROOT_DIR}/common/ports/ARMCMx/compilers/GCC/mk/startup_stm32f4xx.cmake)