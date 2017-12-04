rendering
updateFrameLightingStates: viewports
	| lightingStates transform numberOfLights lightingState |
	lightingStates := globalLightingStates at: engine bufferingFrameIndex.
	
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
			
		(lightingStates at: viewportIndex) value: lightingState
	].

	globalLightingStateBinding := globalLightingStateBindings at: engine bufferingFrameIndex.