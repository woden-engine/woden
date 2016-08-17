event handling
onDoubleClickEvent: event
	| newSelectedCell |
	newSelectedCell := self findCellAtPosition: (self globalPointToLocal: event position - (0@verticalScroll)).
	newSelectedCell ifNil: [ ^ self ].
	
	selectedCell := newSelectedCell.
	editor
		currentMaterialName: selectedCell value;
		applyCurrentMaterialToSelection