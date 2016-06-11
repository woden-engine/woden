rendering
updateLightingState
	| angle viewMatrix |
	viewMatrix := cameraObjectState inverseModelMatrix.
	lightSources at: 1 put: (WTLightSourceData new
		direction: (viewMatrix transformVector3: (WMVector3F x: 0.5 y: 1.0 z: 0.3) normalized);
		intensity: Color lightBlue asWMVector4F *0.8;
		yourself).
	angle := DateAndTime millisecondClockValue *0.001 * Float twoPi * 0.25.
	lightSources at: 2 put: (WTLightSourceData new
		position: (viewMatrix transformPosition3: (WMVector3F x: angle sin *2.0 y: 1.0 z: angle cos * 2.0));
		intensity: Color yellow asWMVector4F *0.8;
		yourself).
	globalLightingState
		numberOfLights: 2;
		lightSources: lightSources.
		
	globalLightingState storeBytesIn: globalLightingStateBuffer validPointer getHandle position: (engine bufferingFrameIndex - 1) * (WTGlobalLightingState structureSize alignedTo: 256) + 1.