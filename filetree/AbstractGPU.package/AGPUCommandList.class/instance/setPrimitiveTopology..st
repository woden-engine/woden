wrappers
setPrimitiveTopology: topology
	| result |
	result := AGPUCBindings setPrimitiveTopology_command_list: (self validHandle) topology: topology.
	self checkErrorCode: result
