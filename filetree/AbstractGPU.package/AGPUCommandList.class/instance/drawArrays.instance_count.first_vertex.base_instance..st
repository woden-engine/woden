wrappers
drawArrays: vertex_count instance_count: instance_count first_vertex: first_vertex base_instance: base_instance
	| result |
	result := AGPUCBindings drawArrays_command_list: (self validHandle) vertex_count: vertex_count instance_count: instance_count first_vertex: first_vertex base_instance: base_instance.
	self checkErrorCode: result
