Class {
	#name : #WDESSimpleUniverse,
	#superclass : #WDESAbstractUniverse,
	#instVars : [
		'mainSector',
		'activeSector'
	],
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #accessing }
WDESSimpleUniverse >> activeSector [
	^ activeSector
]

{ #category : #accessing }
WDESSimpleUniverse >> activeSector: anObject [
	activeSector := anObject
]

{ #category : #'as yet unclassified' }
WDESSimpleUniverse >> activeSectors [
	activeSector ifNotNil: [ ^ { activeSector } ].
	^ #()
]

{ #category : #'as yet unclassified' }
WDESSimpleUniverse >> buildSector: aSector [
	| result |
	result := super buildSector: aSector.
	self activeSector: result.
	^ result
]
