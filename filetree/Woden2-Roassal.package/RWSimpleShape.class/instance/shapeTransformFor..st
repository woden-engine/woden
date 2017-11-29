hooks
shapeTransformFor: anElement
	^ WMReversibleAffineTransformF identity
		scaleByX: (self widthFor: anElement) asFloat
		y: (self heightFor: anElement) asFloat
		z: (self depthFor: anElement) asFloat