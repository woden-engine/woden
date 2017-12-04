initialization
reset
	isChanged := true.
	shaderSignature := nil.
	vertexShader := nil.
	fragmentShader := nil.
	
	frontFaceWinding := AGPU_COUNTER_CLOCKWISE.
	cullMode := AGPU_CULL_MODE_NONE.
	primitiveType := AGPU_POINTS.
	
	depthEnabled := false.
	depthWriteMask := false.
	depthFunction := AGPU_ALWAYS.
	
	renderTargetFormats := #().
	depthStencilFormat := AGPU_TEXTURE_FORMAT_UNKNOWN.
	blendingStates := #().
	sampleCount := 1.
