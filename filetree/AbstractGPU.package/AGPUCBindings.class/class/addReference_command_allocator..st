command_allocator
addReference_command_allocator: command_allocator
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuAddCommandAllocatorReference (agpu_command_allocator* command_allocator) )
