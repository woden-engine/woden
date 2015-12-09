command_list
useIndexBuffer_command_list: command_list index_buffer: index_buffer
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuUseIndexBuffer (agpu_command_list* command_list , agpu_buffer* index_buffer) )
