get_filename_component(CHIBIOS_RT_DIR
    ${CMAKE_CURRENT_LIST_FILE} DIRECTORY)

set(CHIBIOS_RT_SRC
    ${CHIBIOS_RT_DIR}/src/chsys.c
    ${CHIBIOS_RT_DIR}/src/chdebug.c
    ${CHIBIOS_RT_DIR}/src/chvt.c
    ${CHIBIOS_RT_DIR}/src/chschd.c
    ${CHIBIOS_RT_DIR}/src/chthreads.c
    ${CHIBIOS_RT_DIR}/src/chtm.c
    ${CHIBIOS_RT_DIR}/src/chstats.c
    ${CHIBIOS_RT_DIR}/src/chdynamic.c
    ${CHIBIOS_RT_DIR}/src/chregistry.c
    ${CHIBIOS_RT_DIR}/src/chsem.c
    ${CHIBIOS_RT_DIR}/src/chmtx.c
    ${CHIBIOS_RT_DIR}/src/chcond.c
    ${CHIBIOS_RT_DIR}/src/chevents.c
    ${CHIBIOS_RT_DIR}/src/chmsg.c
    ${CHIBIOS_RT_DIR}/src/chmboxes.c
    ${CHIBIOS_RT_DIR}/src/chqueues.c
    ${CHIBIOS_RT_DIR}/src/chmemcore.c
    ${CHIBIOS_RT_DIR}/src/chheap.c
    ${CHIBIOS_RT_DIR}/src/chmempools.c
)

set(CHIBIOS_RT_INCLUDE_DIR
    ${CHIBIOS_RT_DIR}/include)
