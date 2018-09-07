Class {
	#name : #WDPhySphereCollisionShape,
	#superclass : #WDPhyCollisionShape,
	#instVars : [
		'radius'
	],
	#category : #'WodenEngine-Physics-Interface'
}

{ #category : #visiting }
WDPhySphereCollisionShape >> accept: aVisitor [
	^ aVisitor visitSphereShape: self
]

{ #category : #accessing }
WDPhySphereCollisionShape >> radius [
	^ radius
]

{ #category : #accessing }
WDPhySphereCollisionShape >> radius: anObject [
	radius := anObject
]
