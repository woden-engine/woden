transformations
translateBy: translation
	self modifyPositionsApplying: [ :vertex | vertex + translation ]