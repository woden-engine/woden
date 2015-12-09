command_queue
addReference_command_queue: command_queue
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuAddCommandQueueReference (agpu_command_queue* command_queue) )
