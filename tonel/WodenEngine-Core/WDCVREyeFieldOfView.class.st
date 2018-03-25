Class {
	#name : #WDCVREyeFieldOfView,
	#superclass : #Object,
	#instVars : [
		'left',
		'right',
		'top',
		'bottom'
	],
	#category : 'WodenEngine-Core-VR'
}

{ #category : #accessing }
WDCVREyeFieldOfView >> bottom [
	^ bottom
]

{ #category : #accessing }
WDCVREyeFieldOfView >> bottom: anObject [
	bottom := anObject
]

{ #category : #accessing }
WDCVREyeFieldOfView >> left [
	^ left
]

{ #category : #accessing }
WDCVREyeFieldOfView >> left: anObject [
	left := anObject
]

{ #category : #'as yet unclassified' }
WDCVREyeFieldOfView >> reverseDepthNear: nearDistance far: farDistance invertedY: invertedY [
	^ WMMatrix4F reverseDepthFrustumLeft: left tan * nearDistance negated
		right: right tan * nearDistance
		bottom: bottom tan * nearDistance negated
		top: top tan * nearDistance
		near: nearDistance far: farDistance invertedY: invertedY
]

{ #category : #accessing }
WDCVREyeFieldOfView >> right [
	^ right
]

{ #category : #accessing }
WDCVREyeFieldOfView >> right: anObject [
	right := anObject
]

{ #category : #accessing }
WDCVREyeFieldOfView >> top [
	^ top
]

{ #category : #accessing }
WDCVREyeFieldOfView >> top: anObject [
	top := anObject
]
