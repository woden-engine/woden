wrappers
createVertexBinding: layout
	| result |
	result := AGPUCBindings createVertexBinding_device: (self validHandle) layout: (self validHandleOf: layout).
	^ AGPUVertexBinding forHandle: result
