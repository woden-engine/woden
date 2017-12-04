accessing
depthStencilFormat
	depthStencilFormat ifNil: [
		(hasDepth or: [ hasStencil ]) ifTrue: [
			depthStencilFormat := hasStencil ifTrue: [ engine preferredDepthStencilFormat ] ifFalse: [ engine preferredDepthFormat ]
		] ifFalse: [
			depthStencilFormat := AGPU_TEXTURE_FORMAT_UNKNOWN
		]
	].
	^ depthStencilFormat