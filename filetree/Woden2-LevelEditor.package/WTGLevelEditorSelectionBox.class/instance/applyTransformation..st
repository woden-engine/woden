transforming
applyTransformation: aTransform
	super applyTransformation: aTransform.
	self box: (box transformedWith: aTransform)