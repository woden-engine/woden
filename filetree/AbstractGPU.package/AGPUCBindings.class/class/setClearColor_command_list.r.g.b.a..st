command_list
setClearColor_command_list: command_list r: r g: g b: b a: a
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuSetClearColor (agpu_command_list* command_list , agpu_float r , agpu_float g , agpu_float b , agpu_float a) )
