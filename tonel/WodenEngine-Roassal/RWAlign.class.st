Class {
	#name : #RWAlign,
	#superclass : #Object,
	#category : #'WodenEngine-Roassal-Layout'
}

{ #category : #'as yet unclassified' }
RWAlign class >> elements: aCollectionOfElements abovePoint: aPoint [
	aCollectionOfElements do: [ :element |
		element translateToY: element height * 0.5 + aPoint y
	]
]
