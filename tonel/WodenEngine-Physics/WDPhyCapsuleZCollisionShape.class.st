Class {
	#name : #WDPhyCapsuleZCollisionShape,
	#superclass : #WDPhyAbstractCapsuleCollisionShape,
	#category : #'WodenEngine-Physics-Interface'
}

{ #category : #visiting }
WDPhyCapsuleZCollisionShape >> accept: aVisitor [
	^ aVisitor visitCapsuleZShape: self
]
