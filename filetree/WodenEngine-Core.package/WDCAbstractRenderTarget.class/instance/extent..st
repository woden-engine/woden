accessing
extent: anExtent
	| extentChanged frameBufferCount |
	lock critical: [ 
		extentChanged := (width ~= anExtent x) or: [height ~= anExtent y].
		width := anExtent x.
		height := anExtent y.
	
		(extentChanged and: [ framebuffers isNotNil ]) ifTrue: [
			frameBufferCount := framebuffers size.
			self release.
			self createFramebuffers: frameBufferCount
		]
	].
