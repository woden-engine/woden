Class {
	#name : #WDPhyCapsuleYCollisionShape,
	#superclass : #WDPhyAbstractCapsuleCollisionShape,
	#category : #'WodenEngine-Physics-Interface'
}

{ #category : #visiting }
WDPhyCapsuleYCollisionShape >> accept: aVisitor [
	^ aVisitor visitCapsuleYShape: self
]

{ #category : #construction }
WDPhyCapsuleYCollisionShape >> halfExtent: aHalfExtent [
	^ self fullHeight: aHalfExtent y *2.0 innerRadius: ((aHalfExtent x*aHalfExtent x) + (aHalfExtent z*aHalfExtent z)) sqrt
]
