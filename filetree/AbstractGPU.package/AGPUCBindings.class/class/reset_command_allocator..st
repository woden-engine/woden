command_allocator
reset_command_allocator: command_allocator
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuResetCommandAllocator (agpu_command_allocator* command_allocator) )
