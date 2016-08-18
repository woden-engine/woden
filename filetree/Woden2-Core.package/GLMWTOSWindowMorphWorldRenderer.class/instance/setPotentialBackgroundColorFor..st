as yet unclassified
setPotentialBackgroundColorFor: aRenderable
	aRenderable colorValue ifNotNil: [ window borderColor: aRenderable colorValue ]