cmake_minimum_required( VERSION 3.10 )

project( factor )

# TODO: Here goes test for system we are building for

set( TARGET_ARCH linux-x86-64 )

include( "${PROJECT_SOURCE_DIR}/cmake/Config.cmake" )

#$(ENGINE): $(DLL_OBJS)
#	$(TOOLCHAIN_PREFIX)$(LINKER) $(ENGINE) $(DLL_OBJS)
#
#factor-lib: $(ENGINE)

add_library( ${ENGINE} ${DLL_OBJS} )
set_target_properties( ${ENGINE} PROPERTIES OUTPUT_NAME factor )

add_library( factor-lib ALIAS ${ENGINE} )

#factor: $(EXE_OBJS) $(DLL_OBJS)
#	$(TOOLCHAIN_PREFIX)$(CXX) -L. $(DLL_OBJS) \
#		$(CFLAGS) $(CXXFLAGS) -o $(EXECUTABLE) $(LIBS) $(EXE_OBJS)

add_executable( factor ${DLL_OBJS} ${EXE_OBJS} )
set_target_properties( factor PROPERTIES 
    OUTPUT_NAME ${EXECUTABLE}
    COMPILE_OPTIONS "${CMAKE_C_FLAGS};${CMAKE_CXX_FLAGS}"
    COMPILE_DEFINITIONS "${CMAKE_C_DEFINITIONS}"
)
target_link_libraries( factor ${LIBS} )

#factor-console: $(EXE_OBJS) $(DLL_OBJS)
#	$(TOOLCHAIN_PREFIX)$(CXX) -L. $(DLL_OBJS) \
#		$(CFLAGS) $(CXXFLAGS) $(CFLAGS_CONSOLE) -o $(CONSOLE_EXECUTABLE) $(LIBS) $(EXE_OBJS)

# ...

#factor-ffi-test: $(FFI_TEST_LIBRARY)
#
#$(FFI_TEST_LIBRARY): vm/ffi_test.o
#	$(TOOLCHAIN_PREFIX)$(CC) $(CFLAGS) $(FFI_TEST_CFLAGS) $(SHARED_FLAG) -o $(FFI_TEST_LIBRARY) $(TEST_OBJS)

add_custom_target( factor-ffi-test DEPENDS ${FFI_TEST_LIBRARY} )

add_custom_command (
    OUTPUT ${FFI_TEST_LIBRARY}
    COMMAND ${CC} ${CMAKE_C_FLAGS} ${FFI_TEST_CFLAGS} ${SHARED_FLAG} -o ${FFI_TEST_LIBRARY} ${TEST_OBJS}
    MAIN_DEPENDENCY ${PROJECT_SOURCE_DIR}/vm/ffi_test.o
)

#vm/resources.o:
#	$(TOOLCHAIN_PREFIX)$(WINDRES) vm/factor.rs vm/resources.o

# ...

#vm/ffi_test.o: vm/ffi_test.c
#	$(TOOLCHAIN_PREFIX)$(CC) -c $(CFLAGS) $(FFI_TEST_CFLAGS) -std=c99 -o $@ $<

add_custom_command (
    OUTPUT ${PROJECT_SOURCE_DIR}/vm/ffi_test.o
    COMMAND ${CC} -c ${CMAKE_C_FLAGS} ${FFI_TEST_CFLAGS} -std=c99 -o ${PROJECT_SOURCE_DIR}/vm/ffi_test.o ${PROJECT_SOURCE_DIR}/vm/ffi_test.c 
    MAIN_DEPENDENCY ${PROJECT_SOURCE_DIR}/vm/ffi_test.c
)

#vm/master.hpp.gch: vm/master.hpp $(MASTER_HEADERS)
# 	$(TOOLCHAIN_PREFIX)$(CXX) -c -x c++-header $(CFLAGS) $(CXXFLAGS) -o $@ $<

add_custom_command ( 
    OUTPUT ${PROJECT_SOURCE_DIR}/vm/master.hpp.gch
    COMMAND ${CXX} -c -x c++-header ${CMAKE_C_FLAGS} ${CMAKE_CXX_FLAGS} -o ${PROJECT_SOURCE_DIR}/vm/master.hpp.gch ${PROJECT_SOURCE_DIR}/vm/master.hpp
    MAIN_DEPENDENCY ${PROJECT_SOURCE_DIR}/vm/master.hpp
    DEPENDS ${MASTER_HEADERS}
)

#%.o: %.cpp vm/master.hpp.gch
#	$(TOOLCHAIN_PREFIX)$(CXX) -c $(CFLAGS) $(CXXFLAGS) -o $@ $<

file( GLOB_RECURSE CXX_SRCS "${PROJECT_SOURCE_DIR}/**/*.cpp" )
foreach( SRC ${CXX_SRCS} )
    string( REPLACE ".cpp" ".o" OBJ ${SRC} )
    add_custom_command (
        OUTPUT ${OBJ}
        COMMAND ${CXX} -c ${CMAKE_C_FLAGS} ${CMAKE_CXX_FLAGS} -o ${OBJ} ${SRC}
        MAIN_DEPENDENCY ${SRC}
        DEPENDS ${PROJECT_SOURCE_DIR}/vm/master.hpp.gch
    )
endforeach()

#%.o: %.S
#	$(TOOLCHAIN_PREFIX)$(CC) -c $(CFLAGS) $(CXXFLAGS) -o $@ $<

file( GLOB_RECURSE ASM_SRCS "${PROJECT_SOURCE_DIR}/**/*.S" )
foreach( SRC ${ASM_SRCS} )
    string( REPLACE ".S" ".o" OBJ ${SRC} )
    add_custom_command (
        OUTPUT ${OBJ}
        COMMAND ${CC} -c ${CMAKE_C_FLAGS} ${CMAKE_CXX_FLAGS} -o ${OBJ} ${SRC}
        MAIN_DEPENDENCY ${SRC}
    )
endforeach()

#%.o: %.mm vm/master.hpp.gch
#	$(TOOLCHAIN_PREFIX)$(CXX) -c $(CFLAGS) $(CXXFLAGS) -o $@ $<

file( GLOB_RECURSE OBJC_SRCS "${PROJECT_SOURCE_DIR}/**/*.mm" )
foreach( SRC ${OBJC_SRCS} )
    string( REPLACE ".mm" ".o" OBJ ${SRC} )
    add_custom_command (
        OUTPUT ${OBJ}
        COMMAND ${CXX} -c ${CMAKE_C_FLAGS} ${CMAKE_CXX_FLAGS} -o ${OBJ} ${SRC}
        MAIN_DEPENDENCY ${SRC}
        DEPENDS ${PROJECT_SOURCE_DIR}/vm/master.hpp.gch
    )
endforeach()
