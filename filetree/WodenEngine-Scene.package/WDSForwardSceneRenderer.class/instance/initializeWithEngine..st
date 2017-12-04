initialization
initializeWithEngine: aWDCEngine
	super initializeWithEngine: aWDCEngine.
	
	lightSources := SLVMNativeArray for: WTLightSourceData new: 16.
	self createLightingState