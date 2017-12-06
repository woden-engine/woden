construction
sourceFactor: sourceFactor destFactor: destFactor
	^ self new
		enabled: true;
		sourceFactor: sourceFactor;
		destFactor: destFactor;
		operation: AGPU_BLENDING_OPERATION_ADD;
		sourceAlphaFactor: sourceFactor;
		destAlphaFactor: destFactor;
		alphaOperation: AGPU_BLENDING_OPERATION_ADD;
		yourself