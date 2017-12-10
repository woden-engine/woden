shadow mapping
renderShadowMaps
	
	| viewports |
	viewports := (1 to: shadowCastingLightCount) collect: [ :i | (shadowCastingLights at: i) viewportForShadowMap: (shadowMapRenderTargets at: i) camera: mainCamera ].
	
	self shadowSceneRenderer
		currentTime: currentTime;
		renderScene: currentScene viewports: viewports intoStateTracker: stateTracker