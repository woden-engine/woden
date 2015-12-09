device
createCommandAllocator_device: device
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_command_allocator* agpuCreateCommandAllocator (agpu_device* device) )
