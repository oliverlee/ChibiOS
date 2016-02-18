get_filename_component(CHIBIOS_TEST_DIR
    ${CMAKE_CURRENT_LIST_FILE} DIRECTORY)

set(CHIBIOS_TEST_SRC
    ${CHIBIOS_TEST_DIR}/test.c
    ${CHIBIOS_TEST_DIR}/testthd.c
    ${CHIBIOS_TEST_DIR}/testsem.c
    ${CHIBIOS_TEST_DIR}/testmtx.c
    ${CHIBIOS_TEST_DIR}/testmsg.c
    ${CHIBIOS_TEST_DIR}/testmbox.c
    ${CHIBIOS_TEST_DIR}/testevt.c
    ${CHIBIOS_TEST_DIR}/testheap.c
    ${CHIBIOS_TEST_DIR}/testpools.c
    ${CHIBIOS_TEST_DIR}/testdyn.c
    ${CHIBIOS_TEST_DIR}/testqueues.c
    ${CHIBIOS_TEST_DIR}/testsys.c
    ${CHIBIOS_TEST_DIR}/testbmk.c
)

set(CHIBIOS_TEST_INCLUDE_DIR ${CHIBIOS_TEST_DIR})
