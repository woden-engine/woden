opening
openInOSWindow
	| vw |
	vw := RWViewWindow initializeWithEngine: engine.
	vw fullscreen: fullscreen.
	vw view: self.
	^ vw openInOSWindow