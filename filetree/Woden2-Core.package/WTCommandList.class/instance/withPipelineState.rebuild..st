as yet unclassified
withPipelineState: pipelineState rebuild: aBlock
	self validHandle
		reset: allocator validHandle initial_pipeline_state: pipelineState handle.
	aBlock value: handle.
	handle close.