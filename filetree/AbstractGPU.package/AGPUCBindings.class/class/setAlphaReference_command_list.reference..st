command_list
setAlphaReference_command_list: command_list reference: reference
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuSetAlphaReference (agpu_command_list* command_list , agpu_float reference) )
