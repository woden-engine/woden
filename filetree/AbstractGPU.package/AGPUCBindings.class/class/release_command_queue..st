command_queue
release_command_queue: command_queue
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuReleaseCommandQueue (agpu_command_queue* command_queue) )
