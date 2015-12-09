command_list
drawArrays_command_list: command_list vertex_count: vertex_count instance_count: instance_count first_vertex: first_vertex base_instance: base_instance
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuDrawArrays (agpu_command_list* command_list , agpu_uint vertex_count , agpu_uint instance_count , agpu_uint first_vertex , agpu_uint base_instance) )
