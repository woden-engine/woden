rendering
currentTexturedColor
	^  selected ifTrue: [
		lastSelected
			ifTrue: [ LastSelectionColor ]
			ifFalse: [ SelectionColor ]
	] ifFalse: [ brush currentTexturedColor ]