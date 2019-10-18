
cmake_minimum_required( VERSION 3.10 )

project( factor )

include_directories( "vm/" )

set( DLL_OBJS $(PLAF_DLL_OBJS) 
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
	
set( MASTER_HEADERS $(PLAF_MASTER_HEADERS) 
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
		vm/utilities.hp
)

set( VM_SOURCES
vm/aging_collector.cpp
vm/alien.cpp
vm/arrays.cpp
vm/bignum.cpp
vm/byte_arrays.cpp
vm/callbacks.cpp
vm/callstack.cpp
vm/code_blocks.cpp
vm/code_heap.cpp
vm/compaction.cpp
vm/contexts.cpp
vm/cpu-x86.cpp
vm/data_heap_checker.cpp
vm/data_heap.cpp
vm/debug.cpp
vm/dispatch.cpp
vm/entry_points.cpp
vm/errors.cpp
vm/factor.cpp
vm/full_collector.cpp
vm/gc.cpp
vm/image.cpp
vm/inline_cache.cpp
vm/instruction_operands.cpp
vm/io.cpp
vm/jit.cpp
vm/mach_signal.cpp
vm/main-unix.cpp
vm/main-windows.cpp
vm/math.cpp
vm/mvm.cpp
vm/mvm-none.cpp
vm/mvm-unix.cpp
vm/mvm-windows.cpp
vm/nursery_collector.cpp
vm/objects.cpp
vm/object_start_map.cpp
vm/os-freebsd.cpp
vm/os-genunix.cpp
vm/os-linux-arm.cpp
vm/os-linux.cpp
vm/os-unix.cpp
vm/os-windows.cpp
vm/os-windows-x86.32.cpp
vm/os-windows-x86.64.cpp
vm/primitives.cpp
vm/quotations.cpp
vm/run.cpp
vm/safepoints.cpp
vm/sampling_profiler.cpp
vm/strings.cpp
vm/to_tenured_collector.cpp
vm/tuples.cpp
vm/utilities.cpp
vm/vm.cpp
vm/words.cpp
)

set( CXX_STANDARD 11 )
set( CXX_FLAGS ${CXX_FLAGS} )

add_library( factor ${VM_SOURCES} )
