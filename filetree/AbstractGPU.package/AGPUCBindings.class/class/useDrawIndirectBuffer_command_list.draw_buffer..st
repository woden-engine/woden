command_list
useDrawIndirectBuffer_command_list: command_list draw_buffer: draw_buffer
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuUseDrawIndirectBuffer (agpu_command_list* command_list , agpu_buffer* draw_buffer) )
