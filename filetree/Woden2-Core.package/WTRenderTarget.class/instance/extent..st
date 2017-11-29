geometry
extent: anExtent
	| extentChanged |
	extentChanged := (screenWidth ~= anExtent x) or: [screenHeight ~= anExtent y].
	screenWidth := anExtent x.
	screenHeight := anExtent y.
	
	(extentChanged and: [ framebuffers isNotNil ]) ifTrue: [
		self release.
		self createFramebuffers: framebuffers size
	]