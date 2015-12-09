device
createCommandListBundle_device: device allocator: allocator initial_pipeline_state: initial_pipeline_state
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_command_list* agpuCreateCommandListBundle (agpu_device* device , agpu_command_allocator* allocator , agpu_pipeline_state* initial_pipeline_state) )
