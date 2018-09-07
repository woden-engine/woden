Class {
	#name : #WDPhyHeightFieldCollisionShape,
	#superclass : #WDPhyCollisionShape,
	#instVars : [
		'heightTexture'
	],
	#category : #'WodenEngine-Physics-Interface'
}

{ #category : #visiting }
WDPhyHeightFieldCollisionShape >> accept: aVisitor [
	^ aVisitor visitHeightFieldCollisionShape: self
]

{ #category : #accessing }
WDPhyHeightFieldCollisionShape >> heightTexture [
	^ heightTexture
]

{ #category : #accessing }
WDPhyHeightFieldCollisionShape >> heightTexture: anObject [
	heightTexture := anObject
]
