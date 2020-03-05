Class {
	#name : #WDBBabylonCanvas,
	#superclass : #BabylonCanvas,
	#instVars : [
		'surface',
		'physicalToLogicalTransform'
	],
	#category : #'WodenEngine-Babylon'
}

{ #category : #'drawing commands' }
WDBBabylonCanvas >> clear: clearColor [
	surface addCommand: (WDBBabylonClearCommand new
		color: clearColor;
		yourself)
]

{ #category : #'as yet unclassified' }
WDBBabylonCanvas >> drawConvertedShape: aConvertedShape [
	^ aConvertedShape drawWithWodenCanvas: self
]

{ #category : #'as yet unclassified' }
WDBBabylonCanvas >> drawWodenMesh2D: mesh2D [
	mesh2D submeshes do: [ :submesh |
		surface addDrawingCommandMesh: mesh2D submesh: submesh
	].
]

{ #category : #'drawing commands' }
WDBBabylonCanvas >> driver [
	^ surface driver
]

{ #category : #accessing }
WDBBabylonCanvas >> physicalToLogicalTransform [
	^ physicalToLogicalTransform
]

{ #category : #accessing }
WDBBabylonCanvas >> physicalToLogicalTransform: anObject [
	physicalToLogicalTransform := anObject
]

{ #category : #accessing }
WDBBabylonCanvas >> physicalToLogicalTransformPoint: aPoint [
	^ physicalToLogicalTransform transform: aPoint
]

{ #category : #'as yet unclassified' }
WDBBabylonCanvas >> popClipRectangle [
	surface popClipRectangle
]

{ #category : #'as yet unclassified' }
WDBBabylonCanvas >> pushClipRectangle: aRectangle [
	surface pushClipRectangle: aRectangle
]

{ #category : #accessing }
WDBBabylonCanvas >> surface [
	^ surface
]

{ #category : #accessing }
WDBBabylonCanvas >> surface: anObject [
	surface := anObject
]

{ #category : #accessing }
WDBBabylonCanvas >> transform [
	^ surface transform
]
