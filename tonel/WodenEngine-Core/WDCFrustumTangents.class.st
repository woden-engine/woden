Class {
	#name : #WDCFrustumTangents,
	#superclass : #Object,
	#instVars : [
		'left',
		'right',
		'top',
		'bottom'
	],
	#category : #'WodenEngine-Core-VR'
}

{ #category : #accessing }
WDCFrustumTangents >> bottom [
	^ bottom
]

{ #category : #accessing }
WDCFrustumTangents >> bottom: anObject [
	bottom := anObject
]

{ #category : #accessing }
WDCFrustumTangents >> left [
	^ left
]

{ #category : #accessing }
WDCFrustumTangents >> left: anObject [
	left := anObject
]

{ #category : #'as yet unclassified' }
WDCFrustumTangents >> projectionMatrixNear: near far: far invertedY: invertedY [
	^ WMMatrix4F reverseDepthFrustumLeft: left * near right: right * near
		bottom: bottom * near top: top * near
		near: near far: far invertedY: invertedY
]

{ #category : #accessing }
WDCFrustumTangents >> right [
	^ right
]

{ #category : #accessing }
WDCFrustumTangents >> right: anObject [
	right := anObject
]

{ #category : #accessing }
WDCFrustumTangents >> top [
	^ top
]

{ #category : #accessing }
WDCFrustumTangents >> top: anObject [
	top := anObject
]
