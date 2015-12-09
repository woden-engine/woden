initialization
initializeForNewSession
	| deviceOpenInfo |
	platform := AGPU firstPlatform.
	platform ifNil: [ self error: 'Failed to open the AGPU platform' ].
	
	deviceOpenInfo := AGPUDeviceOpenInfo new debug_layer: self class debugLayerEnabled.
	device := platform openDevice: deviceOpenInfo.
	device ifNil: [ self error: 'Failed to open the AGPU device' ].
	
	self createFramebuffer.

	session := Smalltalk session.
	