command_list
setClearStencil_command_list: command_list value: value
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuSetClearStencil (agpu_command_list* command_list , agpu_int value) )
