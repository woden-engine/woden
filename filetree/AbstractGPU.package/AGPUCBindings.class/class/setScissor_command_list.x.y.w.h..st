command_list
setScissor_command_list: command_list x: x y: y w: w h: h
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuSetScissor (agpu_command_list* command_list , agpu_int x , agpu_int y , agpu_int w , agpu_int h) )