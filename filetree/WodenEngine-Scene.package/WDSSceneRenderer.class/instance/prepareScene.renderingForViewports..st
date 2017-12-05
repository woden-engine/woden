rendering preparations
prepareScene: scene renderingForViewports: viewports
	| fullFrameIndex |
	currentScene := scene.
	viewports ifEmpty: [ ^ self ].
	mainCamera := viewports first camera.

	self collectVisibleObjectsFor: mainCamera.
	fullFrameIndex := engine frameBufferingDriver frameIndex.
	visibleObjects select: [:obj | obj useViewportCamera not ] thenDo: [ :obj | obj updateGpuStateForFrame: fullFrameIndex camera: mainCamera].
	objectsPerViewport := viewports collect: [ :viewport |
		visibleObjects select: viewport filter thenCollect: [ :element |
			element useViewportCamera ifTrue: [
				element updateGpuStateForFrame: fullFrameIndex camera: viewport camera
			].
			element
		]
	].
	self sortObjects: objectsPerViewport perViewports: viewports.
	
	self
		updateRenderingStatesFor: viewports