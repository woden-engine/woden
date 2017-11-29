updating screen
checkNewWindowSize
	| newExtent |
	newExtent := osWindow extent.
	newExtent ~= self extent ifTrue: [
		self extent: newExtent
	].
	