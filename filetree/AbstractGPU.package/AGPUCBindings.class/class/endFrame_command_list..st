command_list
endFrame_command_list: command_list
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuEndFrame (agpu_command_list* command_list) )
