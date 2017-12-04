accessing
extent: anExtent
	| extentChanged |
	lock critical: [ 
		extentChanged := (width ~= anExtent x) or: [height ~= anExtent y].
		width := anExtent x.
		height := anExtent y.
	
		(extentChanged and: [ framebuffers isNotNil ]) ifTrue: [
			self release.
			self createFramebuffers: framebuffers size
		]
	].
