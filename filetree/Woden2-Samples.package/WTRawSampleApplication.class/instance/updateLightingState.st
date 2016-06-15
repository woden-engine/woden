rendering
updateLightingState
	| angle viewMatrix renderTime |
	renderTime := currentTime + accumulatedUpdateTime.
	viewMatrix := cameraObjectState inverseMatrix4.
	lightSources at: 1 put: (WTLightSourceData new
		direction: (viewMatrix transformVector3: (WMVector3F x: 0.5 y: 1.0 z: -0.3) normalized);
		intensity: Color lightBlue asWMVector4F *0.8;
		radius: 1.0;
		outerCosCutoff: -1.0;
		yourself).
	angle := renderTime * Float twoPi * 0.4.
	lightSources at: 2 put: (WTLightSourceData new
		position: (viewMatrix transformPosition3: (WMVector3F x: angle sin *1.2 y: 0.8 z: angle cos * 1.2));
		intensity: Color yellow asWMVector4F *0.8;
		radius: 2.0;
		outerCosCutoff: -1.0;
		yourself).
	globalLightingState
		numberOfLights: 2;
		lightSources: lightSources.
		
	globalLightingState storeBytesIn: globalLightingStateBuffer validPointer getHandle position: (engine bufferingFrameIndex - 1) * (WTGlobalLightingState structureSize alignedTo: 256) + 1.