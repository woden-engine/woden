rendering
updateFrameLightingStates: viewports
	| lightingState lightingStateOffset transform numberOfLights globalLightingStateSize cameraStride frameStride |
	
	globalLightingStateSize := WTGlobalLightingState structureSize alignedTo: 256.
	cameraStride := globalLightingStateSize * engine frameBufferingCount.	
	frameStride := globalLightingStateSize.
	
	viewports doWithIndex: [ :viewport :viewportIndex |
		transform := viewport camera transform.
		numberOfLights := visibleLightSources size min: 16.
		1 to: numberOfLights do: [ :lightIndex |
			lightSources at: lightIndex put: ((visibleLightSources at: lightIndex) viewStateFor: transform).
		].

		lightingState := WTGlobalLightingState  new.
		lightingState
			skyLighting: Color darkGray asWMVector4F;
			groundLighting: Color veryDarkGray asWMVector4F;
			sunDirection: (transform inverseTransformVector3: (WMVector3F y: 1.0));
			numberOfLights: numberOfLights;
			lightSources: lightSources.
			
		lightingStateOffset := ((viewportIndex - 1) * cameraStride) + ((currentFrameIndex - 1) * frameStride) + 1.
		lightingState storeBytesIn: globalLightingStateBuffer validPointer getHandle position: lightingStateOffset.
	]