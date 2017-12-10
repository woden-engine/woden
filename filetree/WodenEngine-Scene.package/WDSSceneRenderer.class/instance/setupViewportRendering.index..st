rendering
setupViewportRendering: viewport index: viewportIndex
	stateTracker submode: viewport submode.
	stateTracker
		useShaderResources: (currentCameraStates at: viewportIndex)