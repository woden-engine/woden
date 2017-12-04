accessing
applyTransformation: newTransformation
	transform := newTransformation transformTransform: transform.
	self changed.