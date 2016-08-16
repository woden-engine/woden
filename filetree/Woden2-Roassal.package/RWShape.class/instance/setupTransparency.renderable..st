changing transparency
setupTransparency: node renderable: renderable
	"aWDRenderable blendingMode: transparencyMode."
	self flag: 'TODO: Make proper changes in the renderable'.
	self isTranslucent ifTrue: [ 
		node translucentRenderPriority
	].
	self isAlphaOverTranslucent ifTrue: [ 
		node translucentRenderPriority
	].
