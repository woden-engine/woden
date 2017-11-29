instance creation
open
	| attrs |
	attrs := OSWindowAttributes new.
	attrs
		title: title;
		extent: self extent;
		windowCentered: true;
		visible: false.
		
	screenForm := Form extent: self extent depth: 32.
	self render.
	
	osWindow := OSWindow createWithAttributes: attrs.
	osWindow eventHandler: (WTOSWindowMorphWorldEventHandler new morphicWorld: self).
	osWindowRenderer := osWindow newFormRenderer: screenForm.
	osWindow show.
	
	renderThread := self createRenderThread.