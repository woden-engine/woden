command_list
drawElements_command_list: command_list index_count: index_count instance_count: instance_count first_index: first_index base_vertex: base_vertex base_instance: base_instance
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuDrawElements (agpu_command_list* command_list , agpu_uint index_count , agpu_uint instance_count , agpu_uint first_index , agpu_int base_vertex , agpu_uint base_instance) )
