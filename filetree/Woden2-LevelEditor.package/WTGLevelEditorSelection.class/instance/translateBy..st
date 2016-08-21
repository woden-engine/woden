transforming
translateBy: translation
	| transform |
	transform := WMReversibleAffineTransformD identity translateBy: translation.
	self applyTransformation: transform