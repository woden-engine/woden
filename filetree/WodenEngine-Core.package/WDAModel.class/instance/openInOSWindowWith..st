opening
openInOSWindowWith: aView
	| view |
	view := aView engine: engine model: self.
	view openInOSWindow.
	self addView: view.
	self start.
	^ view