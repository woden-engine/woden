pipeline state
blendingAllEnabled: enabled sourceFactor: sourceFactor destFactor: destFactor operation: operation
	pipelineStateDescription blendingStates: {WDCPipelineStateBlendingState new
		targetMask: -1;
		enabled: enabled;
		sourceFactor: sourceFactor;
		destFactor: destFactor;
		operation: operation;
		sourceAlphaFactor: sourceFactor;
		destAlphaFactor: destFactor;
		alphaOperation: operation;
		yourself
	}