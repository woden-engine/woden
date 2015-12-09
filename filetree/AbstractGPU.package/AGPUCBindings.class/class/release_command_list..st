command_list
release_command_list: command_list
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuReleaseCommandList (agpu_command_list* command_list) )
