command_queue
addCommandList_command_queue: command_queue command_list: command_list
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuAddCommandList (agpu_command_queue* command_queue , agpu_command_list* command_list) )
