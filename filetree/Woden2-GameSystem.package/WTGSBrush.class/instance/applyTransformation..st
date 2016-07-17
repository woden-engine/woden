transformations
applyTransformation: transformation
	self modifyPositionsApplying: [ :v | transformation transformPosition3: v ]