command_list
close_command_list: command_list
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuCloseCommandList (agpu_command_list* command_list) )
