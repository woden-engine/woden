Class {
	#name : #WDPhyCompoundCollisionShapeComponent,
	#superclass : #Object,
	#instVars : [
		'transform',
		'shape'
	],
	#category : #'WodenEngine-Physics-Interface'
}

{ #category : #printing }
WDPhyCompoundCollisionShapeComponent >> printOn: aStream [
	aStream nextPutAll: self class name; space; print: shape; space; print: transform
]

{ #category : #accessing }
WDPhyCompoundCollisionShapeComponent >> shape [
	^ shape
]

{ #category : #accessing }
WDPhyCompoundCollisionShapeComponent >> shape: anObject [
	shape := anObject
]

{ #category : #accessing }
WDPhyCompoundCollisionShapeComponent >> transform [
	^ transform ifNil: [ transform := WMReversibleAffineTransformF identity ]
]

{ #category : #accessing }
WDPhyCompoundCollisionShapeComponent >> transform: anObject [
	transform := anObject
]

{ #category : #accessing }
WDPhyCompoundCollisionShapeComponent >> translation: aTranslation [
	^ self transform translation: aTranslation
]
