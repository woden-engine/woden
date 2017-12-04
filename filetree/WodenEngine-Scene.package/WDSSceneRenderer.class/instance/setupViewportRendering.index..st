rendering
setupViewportRendering: viewport index: viewportIndex
	stateTracker submode: viewport submode.
	stateTracker
		useShaderResources: (cameraUniformBinding at: viewportIndex)