Class {
	#name : #WDESGenericEntity,
	#superclass : #WDESAbstractEntity,
	#instVars : [
		'transform'
	],
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #initialization }
WDESGenericEntity >> initialize [
	super initialize.
	transform := WMReversibleAffineTransformF identity.
]

{ #category : #accessing }
WDESGenericEntity >> transform [
	^ transform
]

{ #category : #accessing }
WDESGenericEntity >> transform: anObject [
	transform := anObject
]
