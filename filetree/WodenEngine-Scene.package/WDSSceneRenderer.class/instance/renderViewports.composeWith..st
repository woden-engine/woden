rendering
renderViewports: viewports composeWith: aBlock
	shadowCastingLightCount ~= 0 ifTrue: [ self renderShadowMaps ].
	
	self setupStateTracker.
	viewports doWithIndex: [ :viewport :index | self renderViewport: viewport index: index ].
	aBlock ifNotNil: [ aBlock cull: stateTracker ]