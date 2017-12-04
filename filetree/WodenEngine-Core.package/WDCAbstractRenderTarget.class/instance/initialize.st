initialization
initialize
	super initialize.
	hasDepth := false.
	hasStencil := false.
	sampleCount := 1.
	lock := Semaphore forMutualExclusion.