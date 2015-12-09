initialization
createPipelineStateManager
	pipelineStateManager ifNil: [
		pipelineStateManager := WTPipelineStateManager new.
		pipelineStateManager initializeForEngine: self.
 	].

	pipelineStateManager sessionChanged