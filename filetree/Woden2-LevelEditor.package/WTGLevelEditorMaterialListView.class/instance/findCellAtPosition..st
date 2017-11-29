event handling
findCellAtPosition: aPosition
	| column row gridExtent cellIndex |
	column := aPosition x asInteger // self computeCellWidth.
	row := aPosition y asInteger // self computeCellHeight.
	
	gridExtent := self computeGridSize.
	(column < 0 or: [ row < 0 ]) ifTrue: [ ^ nil ].
	(column >= gridExtent x or: [ row >= gridExtent y ]) ifTrue: [ ^ nil ].

	cellIndex := (row * gridExtent x) + column + 1.
	cellIndex <= thumbnailCells size ifTrue: [ ^ thumbnailCells at: cellIndex ] ifFalse: [ ^ nil ]