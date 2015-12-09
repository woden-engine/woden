wrappers
useVertexBinding: vertex_binding
	| result |
	result := AGPUCBindings useVertexBinding_command_list: (self validHandle) vertex_binding: (self validHandleOf: vertex_binding).
	self checkErrorCode: result
