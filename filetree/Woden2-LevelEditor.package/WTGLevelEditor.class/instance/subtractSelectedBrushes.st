actions
subtractSelectedBrushes
	| affectedBrushes newBrushes entity |
	selectionBox elements ifEmpty: [ ^ self ].
	affectedBrushes := map findBrushesIntersectingSelectedBrushesProperly: selectionBox.
	affectedBrushes ifEmpty: [ ^ self ].
	
	self flag: 'Add a memento or something for undo/redo'.
	affectedBrushes do: [ :brush |
		selectionBox elements do: [ :subtractor |
			newBrushes := brush subtract: subtractor.
			entity := brush entity.
			entity removeComponent: brush.
			entity addComponents: newBrushes
		]
	]