initialization
initializeWithEngine: aWDCEngine
	engine := aWDCEngine.
	currentTime := 0.0.
	
	visibleObjects := OrderedCollection new.
	visibleLightSources := OrderedCollection new.
