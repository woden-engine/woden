class initialization
initialize
	super initialize.
	
	CellSize := 128.
	CellMargin := 4.
	
	CellHighlightedBackgroundColor := Color lightGray.
	CellSelectedBackgroundColor := Color blue.
	VerticalScrollAmount := 32.
	
	MaterialTypeBlackList := Set newFrom: #(skinned 'no-editor')