initialization
initializeForNewSession
	session := Smalltalk session.
	self
		createDevice;
		queryDeviceCapabilities;
		createResourceCache.
	frameBufferingDriver := WDCFrameBufferingDriver for: self.
