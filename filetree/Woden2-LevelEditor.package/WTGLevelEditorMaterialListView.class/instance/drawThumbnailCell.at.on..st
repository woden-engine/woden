private
drawThumbnailCell: cell at: position on: canvas
	| thumbnailPaint font |
	thumbnailPaint := editor thumbnailPaintCache gpuPaintFor: cell thumbnail value.
	font := self labelFont.
	
	canvas pathTransform restoreAfter: [
		canvas pathTransform translateBy: position.
		
		selectedCell == cell ifTrue: [
			canvas setPaint: CellSelectedBackgroundColor.
			canvas setShape: (0 @ 0 extent: self computeCellExtent).
			canvas draw.
		] ifFalse: [ 
			highlightedCell == cell ifTrue: [
				canvas setPaint: CellHighlightedBackgroundColor.
				canvas setShape: (0 @ 0 extent: self computeCellExtent).
				canvas draw.
			]
		].
		
		canvas setPaint: thumbnailPaint.
			
		canvas setShape: (CellMargin @ CellMargin extent: CellSize @ CellSize).
		canvas draw.
		
		canvas pathTransform restoreAfter: [
			canvas pathTransform translateX: CellMargin Y: font getPreciseAscent + CellMargin + CellSize.

			canvas setFont: self labelFont.
			canvas setPaint: Color black.
			
			canvas drawString: cell label.
		]
	].
