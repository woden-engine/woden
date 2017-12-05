commands
drawArrays: vertex_count instance_count: instance_count first_vertex: first_vertex base_instance: base_instance
	self commitPipelineState.
	commandListBuilder drawArrays: vertex_count instance_count: instance_count first_vertex: first_vertex base_instance: base_instance