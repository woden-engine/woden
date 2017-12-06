converting
asPipelineStateBlendingState
	| result |
	result := WDCPipelineStateBlendingState new.
	result enabled: enabled;
		targetMask: -1;
		sourceFactor: sourceFactor;
		destFactor: destFactor;
		operation: operation;
		sourceAlphaFactor: sourceAlphaFactor;
		destAlphaFactor: destAlphaFactor;
		alphaOperation: alphaOperation.
	^ result