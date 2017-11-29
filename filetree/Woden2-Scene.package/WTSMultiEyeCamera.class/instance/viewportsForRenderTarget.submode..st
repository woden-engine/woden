as yet unclassified
viewportsForRenderTarget: aRenderTarget submode: submode
	| eyeHeight eyeWidth |
	eyeHeight := aRenderTarget screenExtent y.
	eyeWidth := aRenderTarget screenExtent x // eyes size.
	
	^ eyes collectWithIndex: [ :eye :index |
		eye viewportForRenderTarget: aRenderTarget
			bounds: (((index - 1) * eyeWidth)@0 extent: eyeWidth @ eyeHeight)
			submode: submode
	]