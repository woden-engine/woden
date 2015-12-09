device
createCommandAllocator_device: device type: type
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_command_allocator* agpuCreateCommandAllocator (agpu_device* device , agpu_command_list_type type) )
