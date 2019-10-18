include( ${PROJECT_SOURCE_DIR}/cmake/Config.unix )
set( PLAF_DLL_OBJS ${PLAF_DLL_OBJS} vm/os-genunix.o vm/os-linux.o vm/mvm-unix.o)
set( PLAF_MASTER_HEADERS ${PLAF_MASTER_HEADERS} vm/os-genunix.hpp vm/os-linux.hpp )
set( LIBS -ldl -lm -lrt -lpthread -Wl,--export-dynamic )

# clang spams warnings if we use -Wl,--no-as-needed with -c
# -Wl,--no-as-needed is a gcc optimization, not required
# we want to work with g++ aliased as c++ here, too
execute_process( COMMAND ${CXX} "--version" COMMAND grep 'Free Software Foundation' RESULT_VARIABLE IS_GCC )

if (${IS_GCC} EQUAL 0)
	set( SITE_CFLAGS ${SITE_CFLAGS} -Wl,--no-as-needed )
endif()
