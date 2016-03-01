# define the OpenOCD configuration files to use
set(OPENOCD_INTERFACE_CFG "" CACHE FILEPATH "OpenOCD interface configuration file")
set(OPENOCD_TARGET_CFG "" CACHE FILEPATH "OpenOCD target/board configuration file")

# try to locate OpenOCD
find_program(
    OPENOCD_EXE
    NAMES openocd openocd-0.6.0 openocd-0.6.1 openocd-0.8.0 openocd-0.9.0
    PATHS ${OPENOCD_ROOT}
    DOC "OpenOCD program"
)
if(OPENOCD_EXE)
    message("Found OpenOCD: ${OPENOCD_EXE}.")
else()
    message(FATAL_ERROR "OpenOCD not found.")
endif()

# helper macro to create a target using OpenOCD
macro(create_openocd_target custom_name target_to_flash)
    if(OPENOCD_INTERFACE_CFG AND OPENOCD_TARGET_CFG)
        add_custom_target(
            ${custom_name} ALL
            ${OPENOCD_EXE}
            -f ${OPENOCD_INTERFACE_CFG}
            -f ${OPENOCD_TARGET_CFG}
            ${ARGN}
            DEPENDS ${target_to_flash}
        )
    elseif(OPENOCD_INTERFACE_CFG)
        add_custom_target(
            ${custom_name} ALL
            ${OPENOCD_EXE}
            -f ${OPENOCD_INTERFACE_CFG}
            ${ARGN}
            DEPENDS ${target_to_flash}
        )
    elseif(OPENOCD_TARGET_CFG)
        add_custom_target(
            ${custom_name} ALL
            ${OPENOCD_EXE}
            -f ${OPENOCD_TARGET_CFG}
            ${ARGN}
            DEPENDS ${target_to_flash}
        )
    endif()
endmacro()

# create a flash-xxx target
macro(add_flash_target target_to_flash)
    create_openocd_target(
        flash-${target_to_flash}
        ${target_to_flash}
        -c \"init\"
        -c \"reset init\"
        -c \"flash write_image erase $<TARGET_FILE:${target_to_flash}>\"
        -c \"shutdown\"
    )
endmacro()

# create a flash-and-run-xxx target
macro(add_flash_and_run_target target_to_flash)
    create_openocd_target(
        flash-and-run-${target_to_flash}
        ${target_to_flash}
        -c \"debug_level 3\"
        -c \"init\"
        -c \"reset init\"
        -c \"flash write_image erase $<TARGET_FILE:${target_to_flash}>\"
        -c \"reset\"
        -c \"shutdown\"
    )
endmacro()
