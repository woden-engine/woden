rendering preparations
updateRenderingStatesFor: viewports
	super updateRenderingStatesFor: viewports.
	self prepareShadowCastingFor: viewports.
	