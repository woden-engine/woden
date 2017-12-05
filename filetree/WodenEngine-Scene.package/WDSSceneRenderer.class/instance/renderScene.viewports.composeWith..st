rendering
renderScene: scene viewports: viewports composeWith: aBlock
	viewports ifEmpty: [ ^ nil ].

	^ self renderScene: scene viewports: viewports composeWith: aBlock mainResolveRenderTarget: viewports first resolveRenderTarget