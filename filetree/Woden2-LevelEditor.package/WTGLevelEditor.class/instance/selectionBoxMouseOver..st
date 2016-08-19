mouse over
selectionBoxMouseOver: boxIndex
	self selectionBoxViewsDo: [ :view | view mouseOverIndex: boxIndex ].