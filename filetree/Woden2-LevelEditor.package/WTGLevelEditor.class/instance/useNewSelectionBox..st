private
useNewSelectionBox: aBox
	self assert: aBox isNotNil.
	selectionBox ifNotNil: [ selectionBox editor: nil ].
	selection ifNotNil: [ selection editor: nil . selection clearSelectedState ].

	selectionBox := aBox.
	selection := aBox.

	selectionBox ifNotNil: [ selectionBox editor: self; setSelectedState ].
	selectionBoxView ifNotNil: [ selectionBoxView updateNodes ]
	