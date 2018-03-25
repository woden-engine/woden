Class {
	#name : #WTBoxCollisionShape,
	#superclass : #WTCollisionShape,
	#instVars : [
		'halfExtent'
	],
	#category : 'WodenEngine-Physics-Interface'
}

{ #category : #construction }
WTBoxCollisionShape class >> halfExtent: aWDVector3 [
	^self new halfExtent: aWDVector3; yourself
]

{ #category : #'as yet unclassified' }
WTBoxCollisionShape >> accept: aVisitor [
	^ aVisitor visitBoxShape: self
]

{ #category : #accessing }
WTBoxCollisionShape >> halfExtent [
	^ halfExtent copy
]

{ #category : #accessing }
WTBoxCollisionShape >> halfExtent: aWDVector3 [
	halfExtent set: aWDVector3
]

{ #category : #accessing }
WTBoxCollisionShape >> initialize [
	halfExtent := WMVector3F x: 1.0 y: 1.0 z: 1.0
]
