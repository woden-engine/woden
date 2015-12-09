device
createBuffer_device: device description: description initial_data: initial_data
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_buffer* agpuCreateBuffer (agpu_device* device , agpu_buffer_description* description , agpu_pointer initial_data) )
