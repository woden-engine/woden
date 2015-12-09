command_list
setClearDepth_command_list: command_list depth: depth
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuSetClearDepth (agpu_command_list* command_list , agpu_float depth) )
