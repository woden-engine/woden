Class {
	#name : #GLMWoden2Presentation,
	#superclass : #GLMRoassal2Presentation,
	#category : 'Woden2-Roassal-Glamour'
}

{ #category : #'initialize-release' }
GLMWoden2Presentation >> initialize [ 
	super initialize.
	newViewBlock := [ RWView new ].
]

{ #category : #rendering }
GLMWoden2Presentation >> renderGlamorouslyOn: aRenderer [
	self registerAnnouncements.
	^ aRenderer renderWoden2Presentation: self
]
