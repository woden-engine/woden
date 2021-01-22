Class {
	#name : #RWBoundingBox,
	#superclass : #Object,
	#category : #'WodenEngine-Roassal-Layout'
}

{ #category : #'instance creation' }
RWBoundingBox class >> for: elements [
	| result |
	result := BoxF32 empty.
	elements do: [ :each |
		result insertBox: each boundingBox
	].
	^ result
]
