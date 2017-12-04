opening
openInMorphicWith: aView
	| view |
	view := aView engine: engine model: self.
	view openInMorphic.
	self addView: view.
	self start.
	^ view