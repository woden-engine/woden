pipeline states
pipelineStateForDescription: description
	| pso |
	pipelineStates at: description ifPresent: [ :existent | ^ existent ].
	
	pso := self buildPipelineStateWithDescription: description.
	pipelineStates at: pso description put: pso.
	^ pso