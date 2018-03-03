building
buildError: errorMessage
	^ WDCPipelineBuildError new
			pipelineDescription: self;
			signal: errorMessage
