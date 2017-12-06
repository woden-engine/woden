changing transparency
setupTransparency: node renderable: renderable
	node blendingMode: transparencyMode.
	self isTranslucent ifTrue: [ 
		node translucentRenderPriority
	].
	self isAlphaOverTranslucent ifTrue: [ 
		node translucentSortedRenderPriority
	].
