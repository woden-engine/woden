actions
makeBrushEntity
	| selectedBrushes |
	selectedBrushes := selection elements select: #isBrush.
	selectedBrushes ifEmpty: [ ^ self ].
	
	Transcript show: selectedBrushes; cr.