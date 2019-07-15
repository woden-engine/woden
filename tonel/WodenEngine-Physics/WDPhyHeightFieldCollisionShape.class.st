Class {
	#name : #WDPhyHeightFieldCollisionShape,
	#superclass : #WDPhyCollisionShape,
	#instVars : [
		'heightTexture',
		'heightScale',
		'scale',
		'offset',
		'minHeight',
		'maxHeight'
	],
	#category : #'WodenEngine-Physics-Interface'
}

{ #category : #visiting }
WDPhyHeightFieldCollisionShape >> accept: aVisitor [
	^ aVisitor visitHeightFieldCollisionShape: self
]

{ #category : #'as yet unclassified' }
WDPhyHeightFieldCollisionShape >> computeHeightRange [
	| heightRange |
	heightRange := heightTexture valueRange.
	minHeight := heightRange first * heightScale.
	maxHeight := heightRange second * heightScale.

]

{ #category : #accessing }
WDPhyHeightFieldCollisionShape >> heightScale [
	^ heightScale
]

{ #category : #accessing }
WDPhyHeightFieldCollisionShape >> heightScale: anObject [
	heightScale := anObject
]

{ #category : #accessing }
WDPhyHeightFieldCollisionShape >> heightTexture [
	^ heightTexture
]

{ #category : #accessing }
WDPhyHeightFieldCollisionShape >> heightTexture: anObject [
	heightTexture := anObject
]

{ #category : #accessing }
WDPhyHeightFieldCollisionShape >> maxHeight [
	maxHeight ifNil: [ self computeHeightRange ].
	^ maxHeight
]

{ #category : #accessing }
WDPhyHeightFieldCollisionShape >> minHeight [
	minHeight ifNil: [ self computeHeightRange ].
	^ minHeight
]

{ #category : #accessing }
WDPhyHeightFieldCollisionShape >> offset [
	^ offset
]

{ #category : #accessing }
WDPhyHeightFieldCollisionShape >> offset: anObject [
	offset := anObject
]

{ #category : #'as yet unclassified' }
WDPhyHeightFieldCollisionShape >> physicsTranslatedOrigin [
	^ WMVector3F y: (self maxHeight + self minHeight) * -0.5
]

{ #category : #accessing }
WDPhyHeightFieldCollisionShape >> scale [
	^ scale
]

{ #category : #accessing }
WDPhyHeightFieldCollisionShape >> scale: anObject [
	scale := anObject
]
