"
This is an utility class for moving a group of elements.
"
Class {
	#name : #RWMove,
	#superclass : #Object,
	#category : 'WodenEngine-Roassal-Layout'
}

{ #category : #'as yet unclassified' }
RWMove class >> boundingBoxOfElements: aCollection [
	| bbox |
	bbox := BoxF32 new.
	aCollection do: [ :each | bbox insertBox: each boundingBox ].
	^ bbox
]

{ #category : #'as yet unclassified' }
RWMove class >> centerElements: elements [
	self centerElements: elements at: Float32x3 new
]

{ #category : #'as yet unclassified' }
RWMove class >> centerElements: elements at: aPoint [
	| translation |
	translation := aPoint - (self boundingBoxOfElements: elements) center.
	elements do: [ :el | el translateBy: translation ]
	
]

{ #category : #'as yet unclassified' }
RWMove class >> placeElements: aCollection onTopOf: aPoint [

	| translation |
	self centerElements: aCollection at: aPoint.
	
	translation := aPoint y - (self boundingBoxOfElements: aCollection) bottom.
	aCollection do: [ :el | el translateByY: translation  ]
]
