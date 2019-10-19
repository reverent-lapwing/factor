set( VERSION 0.99 )
execute_process( COMMAND echo "`git describe --all`-`git rev-parse HEAD`" OUTPUT_VARIABLE GIT_LABEL )
set( BUNDLE Factor.app )
if( NOT DEFINED DEBUG )
    set( DEBUG 0 )
endif()
if( NOT DEFINED REPRODUCIBLE )
    set( REPRODUCIBLE 0 )
endif()

# gmake's default CXX is g++, we prefer c++
execute_process( COMMAND shell printenv CXX OUTPUT_VARIABLE SHELL_CXX )
if( SHELL_CXX STREQUAL "" )
    set( CXX c++ )
else()
    set( CXX ${SHELL_CXX} )
endif()
execute_process( COMMAND shell printenv CC OUTPUT_VARIABLE SHELL_CC )
if( SHELL_CC STREQUAL "" )
    set( CC gcc )
else()
    set( CC ${SHELL_CC} )
endif()

if( NOT DEFINED XCODE_PATH )
    set(XCODE_PATH /Applications/Xcode.app)
endif()
if( NOT DEFINED MACOSX_32_SDK )
    set(MACOSX_32_SDK MacOSX10.11.sdk)
endif()
if( NOT DEFINED XCODE_PATH )
    set(MACOSX_SDK MacOSX10.13.sdk)
endif()

if( ${TARGET_ARCH} STREQUAL "linux-x86-64" )
  include( "${PROJECT_SOURCE_DIR}/cmake/Config.linux.x86.64.cmake" )
else()
   message( FATAL_ERROR "Unsupported target architecture - \"${TARGET_ARCH}\"" )
endif()

set( CMAKE_C_FLAGS ${CMAKE_C_FLAGS} -Wall -pedantic ${SITE_CFLAGS} )
set( CMAKE_C_DEFINITIONS ${CMAKE_C_DEFINITIONS} "-DFACTOR_VERSION=$(VERSION) -DFACTOR_GIT_LABEL=$(GIT_LABEL)" )

set( CXX_STANDARD 11 )

if( NOT ( ${DEBUG} EQUAL 0 ) )
    set( CMAKE_C_FLAGS ${CMAKE_C_FLAGS} -g )
    set( CMAKE_C_DEFINITIONS ${CMAKE_C_DEFINITIONS} "-DFACTOR_DEBUG" )
else()
    set( CMAKE_C_FLAGS ${CMAKE_C_FLAGS} -O3 )
endif()

if ( NOT ( ${REPRODUCIBLE} EQUAL 0 ) )
    set( CMAKE_C_DEFINITIONS ${CMAKE_C_DEFINITIONS} "-DFACTOR_REPRODUCIBLE" )
endif()

set( ENGINE "${DLL_PREFIX}factor${DLL_SUFFIX}${DLL_EXTENSION}" )
set( EXECUTABLE "factor${EXE_SUFFIX}${EXE_EXTENSION}" )
set( CONSOLE_EXECUTABLE "factor${EXE_SUFFIX}${CONSOLE_EXTENSION}" )

set( DLL_OBJS ${PLAF_DLL_OBJS}
	vm/aging_collector.o
	vm/alien.o
	vm/arrays.o
	vm/bignum.o
	vm/byte_arrays.o
	vm/callbacks.o
	vm/callstack.o
	vm/code_blocks.o
	vm/code_heap.o
	vm/compaction.o
	vm/contexts.o
	vm/data_heap.o
	vm/data_heap_checker.o
	vm/debug.o
	vm/dispatch.o
	vm/entry_points.o
	vm/errors.o
	vm/factor.o
	vm/full_collector.o
	vm/gc.o
	vm/image.o
	vm/inline_cache.o
	vm/instruction_operands.o
	vm/io.o
	vm/jit.o
	vm/math.o
	vm/mvm.o
	vm/nursery_collector.o
	vm/object_start_map.o
	vm/objects.o
	vm/primitives.o
	vm/quotations.o
	vm/run.o
	vm/safepoints.o
	vm/sampling_profiler.o
	vm/strings.o
	vm/to_tenured_collector.o
	vm/tuples.o
	vm/utilities.o
	vm/vm.o
	vm/words.o
)

set( MASTER_HEADERS ${PLAF_MASTER_HEADERS}
	vm/assert.hpp
	vm/debug.hpp
	vm/layouts.hpp
	vm/platform.hpp
	vm/primitives.hpp
	vm/segments.hpp
	vm/gc_info.hpp
	vm/contexts.hpp
	vm/run.hpp
	vm/objects.hpp
	vm/sampling_profiler.hpp
	vm/errors.hpp
	vm/bignumint.hpp
	vm/bignum.hpp
	vm/booleans.hpp
	vm/instruction_operands.hpp
	vm/code_blocks.hpp
	vm/bump_allocator.hpp
	vm/bitwise_hacks.hpp
	vm/mark_bits.hpp
	vm/free_list.hpp
	vm/fixup.hpp
	vm/write_barrier.hpp
	vm/object_start_map.hpp
	vm/aging_space.hpp
	vm/tenured_space.hpp
	vm/data_heap.hpp
	vm/code_heap.hpp
	vm/gc.hpp
	vm/float_bits.hpp
	vm/io.hpp
	vm/image.hpp
	vm/callbacks.hpp
	vm/dispatch.hpp
	vm/vm.hpp
	vm/allot.hpp
	vm/tagged.hpp
	vm/data_roots.hpp
	vm/code_roots.hpp
	vm/generic_arrays.hpp
	vm/callstack.hpp
	vm/slot_visitor.hpp
	vm/to_tenured_collector.hpp
	vm/arrays.hpp
	vm/math.hpp
	vm/byte_arrays.hpp
	vm/jit.hpp
	vm/quotations.hpp
	vm/inline_cache.hpp
	vm/mvm.hpp
	vm/factor.hpp
	vm/utilities.hpp
)

set(EXE_OBJS ${PLAF_EXE_OBJS})

set(FFI_TEST_LIBRARY libfactor-ffi-test${SHARED_DLL_EXTENSION})

set(TEST_OBJS ${PROJECT_SOURCE_DIR}/vm/ffi_test.o)
