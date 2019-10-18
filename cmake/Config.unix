if (DEBUG EQUAL "0")
	set( SITE_CFLAGS ${SITE_CFLAGS} -fomit-frame-pointer )
endif()

set( EXE_SUFFIX )
set( DLL_PREFIX lib )
set( DLL_EXTENSION .a )
set( SHARED_DLL_EXTENSION .so )
set( SHARED_FLAG -shared )

set( PLAF_DLL_OBJS ${PLAF_DLL_OBJS} vm/os-unix.o )
set( PLAF_EXE_OBJS ${PLAF_EXE_OBJS} vm/main-unix.o )
set( PLAF_MASTER_HEADERS ${PLAF_MASTER_HEADERS} vm/os-unix.hpp )

set( FFI_TEST_CFLAGS -fPIC )

# LINKER = gcc -shared -o
# LINK_WITH_ENGINE = '-Wl,-rpath,$$ORIGIN' -lfactor

set( LINKER $(AR) rcs )
set( LINK_WITH_ENGINE -Wl,--whole-archive -lfactor -Wl,-no-whole-archive )
