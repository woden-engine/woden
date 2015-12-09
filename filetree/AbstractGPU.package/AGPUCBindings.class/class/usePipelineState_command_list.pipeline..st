command_list
usePipelineState_command_list: command_list pipeline: pipeline
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuUsePipelineState (agpu_command_list* command_list , agpu_pipeline_state* pipeline) )
