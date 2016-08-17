private
drawThumbnailsOn: aCanvas
	| cellWidth cellHeight columns rows rowIndex columnIndex gridSize thumbnailPosition |
	self ensureThumbnailDataIsUpdated.
	thumbnailCells ifEmpty: [ ^ self ].
	
	cellWidth := self computeCellWidth.
	cellHeight := self computeCellHeight.
	
	gridSize := self computeGridSize.
	columns := gridSize x.
	rows := gridSize y.

	thumbnailCells doWithIndex: [ :cell :index |
		rowIndex := (index - 1) // columns.
		columnIndex := (index - 1) \\ columns.
		thumbnailPosition := (columnIndex*cellWidth) @ (rowIndex*cellHeight + verticalScroll).
		thumbnailPosition y > self height ifTrue: [ ^ self ].
		self drawThumbnailCell: cell at: thumbnailPosition on: aCanvas
	].
