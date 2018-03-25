Class {
	#name : #GLMMorphicWodenRenderer,
	#superclass : #GLMMorphicRoassal2Renderer,
	#category : 'Woden2-Roassal-Glamour'
}

{ #category : #rendering }
GLMMorphicWodenRenderer >> render: aRoassalPresentation [
	| view |
	view := aRoassalPresentation view.
	aRoassalPresentation when: GLMPresentationUpdated send: #actOnPresentationUpdate: to: self.
	^ myMorph := (RWViewWindow new view: view) morphicWindow
	
]
