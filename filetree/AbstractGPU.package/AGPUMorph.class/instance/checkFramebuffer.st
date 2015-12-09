initialization
checkFramebuffer
	| innerBounds currentWidth currentHeight |
	innerBounds := self innerBounds.
	currentWidth := innerBounds width asInteger.
	currentHeight := innerBounds height asInteger.
	(currentWidth ~= screenWidth or: [ currentHeight ~= screenHeight ]) ifTrue: [ 
		mainFramebuffer release.
		mainColorbuffer release.
		mainDepthbuffer ifNotNil: [
			mainDepthbuffer release.
		].
	
		self createFramebuffer
	]