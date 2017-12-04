pipeline state building
applyOn: builder
	builder setBlendState: targetMask enabled: enabled.
	enabled ifTrue: [
		builder setBlendFunction: targetMask
		sourceFactor: sourceFactor destFactor: destFactor colorOperation: operation
		sourceAlphaFactor: sourceAlphaFactor destAlphaFactor: destAlphaFactor alphaOperation: alphaOperation
	].