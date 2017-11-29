accessing
currentTexturedColor
	^ selected ifTrue: [
		lastSelected
			ifTrue: [ LastSelectionColor ]
			ifFalse: [ SelectionColor ]
	] ifFalse: [ Color white]