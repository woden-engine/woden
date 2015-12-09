command_queue
finishExecution_command_queue: command_queue
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuFinishQueueExecution (agpu_command_queue* command_queue) )
