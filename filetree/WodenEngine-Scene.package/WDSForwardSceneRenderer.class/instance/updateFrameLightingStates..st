rendering
updateFrameLightingStates: viewports
	| transform numberOfLights lightingState gpuLightingStates lightSource shadowMapIndex |
	self ensureLightingStatesFor: viewports size.
	currentGlobalLigthingStates := globalLightingStates at: engine bufferingFrameIndex.
	
	viewports doWithIndex: [ :viewport :viewportIndex |
		transform := viewport cameraTransform.
		numberOfLights := visibleLightSources size min: 16.
		1 to: numberOfLights do: [ :lightIndex |
			lightSource := (visibleLightSources at: lightIndex) first.
			shadowMapIndex := shadowCastingLights indexOf: lightSource ifAbsent: [ 0 ].
			lightSources at: lightIndex put: (lightSource viewStateFor: transform engine: engine shadowMapIndex: shadowMapIndex - 1).
		].

		lightingState := WTGlobalLightingState  new.
		lightingState
			skyLighting: Color darkGray asWMVector4F;
			groundLighting: Color veryDarkGray asWMVector4F;
			sunDirection: (transform inverseTransformVector3: (WMVector3F y: 1.0));
			numberOfLights: numberOfLights;
			lightSources: lightSources.
			
		gpuLightingStates := (currentGlobalLigthingStates at: viewportIndex) slotValueAt: 0.
		gpuLightingStates value: lightingState.
	].