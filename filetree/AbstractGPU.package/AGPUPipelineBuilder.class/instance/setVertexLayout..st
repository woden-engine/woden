wrappers
setVertexLayout: layout
	| result |
	result := AGPUCBindings setVertexLayout_pipeline_builder: (self validHandle) layout: (self validHandleOf: layout).
	self checkErrorCode: result
