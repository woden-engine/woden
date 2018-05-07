Class {
	#name : #WDPPompeiiCanvas,
	#superclass : #PompeiiCanvas,
	#instVars : [
		'surface'
	],
	#category : #'WodenEngine-Pompeii'
}

{ #category : #'drawing commands' }
WDPPompeiiCanvas >> clear: clearColor [
	surface addCommand: (WDPPompeiiClearCommand new
		color: clearColor;
		yourself)
]

{ #category : #'as yet unclassified' }
WDPPompeiiCanvas >> drawConvertedShape: aConvertedShape [
	^ aConvertedShape drawWithWodenCanvas: self
]

{ #category : #'as yet unclassified' }
WDPPompeiiCanvas >> drawWodenMesh2D: mesh2D [
	mesh2D submeshes do: [ :submesh |
		surface addDrawingCommandMesh: mesh2D submesh: submesh
	].
]

{ #category : #'drawing commands' }
WDPPompeiiCanvas >> driver [
	^ surface driver
]

{ #category : #accessing }
WDPPompeiiCanvas >> surface [
	^ surface
]

{ #category : #accessing }
WDPPompeiiCanvas >> surface: anObject [
	surface := anObject
]

{ #category : #accessing }
WDPPompeiiCanvas >> transform [
	^ surface transform
]
