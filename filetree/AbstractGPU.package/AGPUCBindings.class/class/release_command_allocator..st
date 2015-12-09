command_allocator
release_command_allocator: command_allocator
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuReleaseCommandAllocator (agpu_command_allocator* command_allocator) )
