instance creation
open
	| attrs |
	attrs := OSWindowAttributes new.
	attrs 
		extent: self defaultExtent;
		visible: false;
		windowCentered: true.
		
	window := OSWindow createWithAttributes: attrs.
	window eventHandler: self;
		show.
	
	self createRenderTarget.
