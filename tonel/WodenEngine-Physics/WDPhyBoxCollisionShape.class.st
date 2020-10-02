Class {
	#name : #WDPhyBoxCollisionShape,
	#superclass : #WDPhyCollisionShape,
	#instVars : [
		'halfExtent'
	],
	#category : #'WodenEngine-Physics-Interface'
}

{ #category : #construction }
WDPhyBoxCollisionShape class >> halfExtent: aWDVector3 [
	^self new halfExtent: aWDVector3; yourself
]

{ #category : #'as yet unclassified' }
WDPhyBoxCollisionShape >> accept: aVisitor [
	^ aVisitor visitBoxShape: self
]

{ #category : #accessing }
WDPhyBoxCollisionShape >> halfExtent [
	^ halfExtent copy
]

{ #category : #accessing }
WDPhyBoxCollisionShape >> halfExtent: aWDVector3 [
	halfExtent := aWDVector3 copy
]

{ #category : #accessing }
WDPhyBoxCollisionShape >> initialize [
	halfExtent := Float32x3 x: 1.0 y: 1.0 z: 1.0
]
