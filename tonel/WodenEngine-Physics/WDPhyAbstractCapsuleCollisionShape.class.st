Class {
	#name : #WDPhyAbstractCapsuleCollisionShape,
	#superclass : #WDPhyCollisionShape,
	#instVars : [
		'radius',
		'height'
	],
	#category : #'WodenEngine-Physics-Interface'
}

{ #category : #'as yet unclassified' }
WDPhyAbstractCapsuleCollisionShape >> fullHeight: fullHeight innerRadius: innerRadius [
	self
		height: fullHeight - (innerRadius*2.0);
		radius: innerRadius
]

{ #category : #accessing }
WDPhyAbstractCapsuleCollisionShape >> height [
	^ height
]

{ #category : #accessing }
WDPhyAbstractCapsuleCollisionShape >> height: anObject [
	height := anObject
]

{ #category : #accessing }
WDPhyAbstractCapsuleCollisionShape >> radius [
	^ radius
]

{ #category : #accessing }
WDPhyAbstractCapsuleCollisionShape >> radius: anObject [
	radius := anObject
]
