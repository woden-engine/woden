command_list
clear_command_list: command_list buffers: buffers
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuClear (agpu_command_list* command_list , agpu_bitfield buffers) )
