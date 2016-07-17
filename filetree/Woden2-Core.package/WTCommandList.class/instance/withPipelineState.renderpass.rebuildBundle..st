as yet unclassified
withPipelineState: pipelineState renderpass: renderpass rebuildBundle: aBlock
	| inheritance |
	inheritance := AGPUInheritanceInfo new.
	inheritance renderpass: renderpass validHandle validHandle.
	
	self validHandle
		resetBundle: allocator validHandle initial_pipeline_state: (pipelineState ifNotNil: [ pipelineState validHandle ]) inheritance_info: inheritance.
	aBlock value: handle.
	handle close.