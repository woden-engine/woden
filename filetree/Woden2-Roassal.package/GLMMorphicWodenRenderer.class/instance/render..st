rendering
render: aRoassalPresentation
	| view |
	view := aRoassalPresentation view.
	aRoassalPresentation when: GLMPresentationUpdated send: #actOnPresentationUpdate: to: self.
	^ myMorph := (RWViewWindow new view: view) morphicWindow
	