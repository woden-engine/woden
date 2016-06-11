initialization
initializeForNewSession
	session := Smalltalk session.
	self
		createDevice;
		queryDeviceCapabilities;
		createPipelineStateManager;
		createFontManager;
		createFrameFences.
	
	
	projectionInvertedY := device hasTopLeftNdcOrigin ~= 0.