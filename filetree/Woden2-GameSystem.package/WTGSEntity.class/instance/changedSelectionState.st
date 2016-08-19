changing
changedSelectionState
	pointEntityNode ifNil: [ ^ self ].
	
	pointEntityNode color: self currentColor.