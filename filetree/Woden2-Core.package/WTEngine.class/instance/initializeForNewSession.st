initialization
initializeForNewSession
	session := Smalltalk session.
	self
		createDevice;
		queryDeviceCapabilities;
		createPipelineStateCache;
		createFontCache;
		createResourceCache;
		createFrameFences.
	
	
	projectionInvertedY := device hasTopLeftNdcOrigin ~= 0.