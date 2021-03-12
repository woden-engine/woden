Class {
	#name : #RWAlign,
	#superclass : #Object,
	#category : #'WodenEngine-Roassal-Layout'
}

{ #category : #'as yet unclassified' }
RWAlign class >> elements: aCollectionOfElements abovePoint: aPoint [
	aCollectionOfElements do: [ :element |
		element translateByY: aPoint y - element boundingBox min y
	]
]
