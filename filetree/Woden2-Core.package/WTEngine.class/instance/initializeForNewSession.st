initialization
initializeForNewSession
	self createDevice.
	self createPipelineStateManager.
	self createFontManager.
	self createFrameFences.
	
	session := Smalltalk session.
	projectionInvertedY := device hasTopLeftNdcOrigin ~= 0.