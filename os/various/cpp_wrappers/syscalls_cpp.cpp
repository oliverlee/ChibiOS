#include <stdio.h>
#include <errno.h>

#include "osal.h"

#include "syscalls_cpp.hpp"

#ifdef __cplusplus
extern "C" {
#endif

#ifdef LTO_SYSCALL_UNDEFINED_REFERNCE_WORKAROUND
__attribute__((used))
#endif
void _exit(int status){
   (void) status;
   osalSysHalt("Unrealized");
   while(TRUE){}
}

#ifdef LTO_SYSCALL_UNDEFINED_REFERNCE_WORKAROUND
__attribute__((used))
#endif
pid_t _getpid(void){
   return 1;
}

#undef errno
extern int errno;
#ifdef LTO_SYSCALL_UNDEFINED_REFERNCE_WORKAROUND
__attribute__((used))
#endif
int _kill(int pid, int sig) {
  (void)pid;
  (void)sig;
  errno = EINVAL;
  return -1;
}

void _open_r(void){
  return;
}

void __cxa_pure_virtual() {
  osalSysHalt("Pure virtual function call.");
}

#ifdef __cplusplus
}
#endif
