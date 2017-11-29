initialization
createPipelineStateCache
	pipelineStateCache ifNil: [
		pipelineStateCache := WTPipelineStateCache new.
		pipelineStateCache initializeForEngine: self.
 	].

	pipelineStateCache sessionChanged