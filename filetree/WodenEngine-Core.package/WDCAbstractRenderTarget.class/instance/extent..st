accessing
extent: anExtent
	| extentChanged frameBufferCount |
	engine renderingProcessCritical: [ 
		extentChanged := (width ~= anExtent x) or: [height ~= anExtent y].
		width := anExtent x.
		height := anExtent y.
	
		(extentChanged and: [ framebuffers isNotNil ]) ifTrue: [
			engine trace: 'Framebuffer extent changed'.
			frameBufferCount := framebuffers size.
			self release.
			self createFramebuffers: frameBufferCount
		]
	].
