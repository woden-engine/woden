wrappers
drawElements: index_count instance_count: instance_count first_index: first_index base_vertex: base_vertex base_instance: base_instance
	| result |
	result := AGPUCBindings drawElements_command_list: (self validHandle) index_count: index_count instance_count: instance_count first_index: first_index base_vertex: base_vertex base_instance: base_instance.
	self checkErrorCode: result
