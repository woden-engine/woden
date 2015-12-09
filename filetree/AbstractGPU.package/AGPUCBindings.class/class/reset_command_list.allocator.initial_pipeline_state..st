command_list
reset_command_list: command_list allocator: allocator initial_pipeline_state: initial_pipeline_state
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuResetCommandList (agpu_command_list* command_list , agpu_command_allocator* allocator , agpu_pipeline_state* initial_pipeline_state) )
