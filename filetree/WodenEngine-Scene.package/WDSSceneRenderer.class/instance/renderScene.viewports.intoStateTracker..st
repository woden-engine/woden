rendering
renderScene: scene viewports: viewports intoStateTracker: aStateTracker
	viewports isEmpty ifTrue: [ ^ nil ].

	stateTracker := aStateTracker.
	self prepareScene: scene renderingForViewports: viewports.	

	self setupStateTracker.
	viewports doWithIndex: [ :viewport :index | self renderViewport: viewport index: index ].