initialization
initialize
	super initialize.
	hasDepth := false.
	hasStencil := false.
	properties := Dictionary new.
	currentFramebufferIndex := 1.