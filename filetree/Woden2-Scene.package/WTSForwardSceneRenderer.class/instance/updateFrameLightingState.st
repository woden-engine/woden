rendering
updateFrameLightingState
	| lightingState lightingStateOffset transform numberOfLights |
	transform := currentCamera transform.
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
			
	lightingStateOffset := (currentFrameIndex - 1) * (WTGlobalLightingState structureSize alignedTo: 256) + 1.
	lightingState storeBytesIn: globalLightingStateBuffer validPointer getHandle position: lightingStateOffset.