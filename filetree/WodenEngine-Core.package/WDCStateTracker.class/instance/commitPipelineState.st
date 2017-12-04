pipeline state
commitPipelineState
	| pipelineState |
	pipelineStateDescription isChanged ifFalse: [ ^ self ].

	pipelineState := engine resourceCache pipelineStateForDescription: pipelineStateDescription.
	pipelineStateDescription isChanged: false.
	commandListBuilder usePipelineState: pipelineState handle