command_list
setStencilReference_command_list: command_list reference: reference
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuSetStencilReference (agpu_command_list* command_list , agpu_uint reference) )
