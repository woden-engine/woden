selection
selectionBox: aBox
	self assert: aBox isNotNil.
	selectionBox ifNotNil: [ selectionBox editor: nil ].
	selectionBox := aBox.
	selectionBox ifNotNil: [ selectionBox editor: self ].
	selectionBoxView ifNotNil: [ selectionBoxView updateNodes ]