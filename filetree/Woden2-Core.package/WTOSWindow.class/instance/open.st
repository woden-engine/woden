instance creation
open
	| attrs |
	attrs := OSWindowAttributes new.
	attrs 
		extent: self defaultExtent;
		windowCentered: true.
		
	window := OSWindow createWithAttributes: attrs.
	self createSwapChain.
	window eventHandler: (self createEventHandler).
	
	drawingProcess := self createDrawingProcess.
	application ifNotNil: [ application windowOpened: self ]