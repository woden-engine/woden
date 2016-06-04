as yet unclassified
strokePath: aPath withStrokePaint: aStrokePaint
	| pixelScaleFactors lineWidth pixelScaleFactor |
	pixelScaleFactors := pathTransform matrix topLeft2x2 eigenValues collect: #abs.
	pixelScaleFactor := pixelScaleFactors first max: pixelScaleFactors second.
	lineWidth := aStrokePaint width * pixelScaleFactor.
	lineWidth < 0.6 ifTrue: [ ^ self ].
	lineWidth < 1.5 ifTrue: [
		self strokeThinPath: aPath withStrokePaint: aStrokePaint
	] ifFalse: [
		Transcript show: 'Stroke non thin-path: ', lineWidth printString; cr.
		self strokeThinPath: aPath withStrokePaint: aStrokePaint
	]
	