command_queue
signalFence_command_queue: command_queue fence: fence
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuSignalFence (agpu_command_queue* command_queue , agpu_fence* fence) )
