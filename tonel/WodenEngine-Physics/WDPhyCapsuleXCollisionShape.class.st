Class {
	#name : #WDPhyCapsuleXCollisionShape,
	#superclass : #WDPhyAbstractCapsuleCollisionShape,
	#category : #'WodenEngine-Physics-Interface'
}

{ #category : #visiting }
WDPhyCapsuleXCollisionShape >> accept: aVisitor [
	^ aVisitor visitCapsuleXShape: self
]
