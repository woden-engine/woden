command_list
drawElementsIndirect_command_list: command_list offset: offset
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuDrawElementsIndirect (agpu_command_list* command_list , agpu_size offset) )
