event handling
onMouseMoveEvent: event
	highlightedCell := self findCellAtPosition: (self globalPointToLocal: event position - (0@verticalScroll))