command_list
addReference_command_list: command_list
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuAddCommandListReference (agpu_command_list* command_list) )
