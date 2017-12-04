rendering
setupViewportRendering: viewport index: viewportIndex
	super setupViewportRendering: viewport index: viewportIndex.
	stateTracker
		useShaderResources: (globalLightingStateBinding at: viewportIndex)