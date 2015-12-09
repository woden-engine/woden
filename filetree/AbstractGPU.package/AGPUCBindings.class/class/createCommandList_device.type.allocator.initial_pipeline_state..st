device
createCommandList_device: device type: type allocator: allocator initial_pipeline_state: initial_pipeline_state
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_command_list* agpuCreateCommandList (agpu_device* device , agpu_command_list_type type , agpu_command_allocator* allocator , agpu_pipeline_state* initial_pipeline_state) )
