Class {
	#name : #WTSphereCollisionShape,
	#superclass : #WTCollisionShape,
	#instVars : [
		'radius'
	],
	#category : 'WodenEngine-Physics-Interface'
}

{ #category : #'as yet unclassified' }
WTSphereCollisionShape >> accept: aVisitor [
	^ aVisitor visitSphereShape: self
]

{ #category : #accessing }
WTSphereCollisionShape >> radius [
	^ radius
]

{ #category : #accessing }
WTSphereCollisionShape >> radius: anObject [
	radius := anObject
]
