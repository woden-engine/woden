Class {
	#name : #WDCAbstractVRSystem,
	#superclass : #Object,
	#instVars : [
		'engine'
	],
	#category : #'WodenEngine-Core-VR'
}

{ #category : #'instance creation' }
WDCAbstractVRSystem class >> for: anEngine [
	^ self new initializeWithEngine: anEngine
]

{ #category : #accessing }
WDCAbstractVRSystem >> engine [
	^ engine
]

{ #category : #testing }
WDCAbstractVRSystem >> hasSupportForVR [
	^ true
]

{ #category : #initialization }
WDCAbstractVRSystem >> initializeWithEngine: anEngine [
	engine := anEngine
]

{ #category : #testing }
WDCAbstractVRSystem >> isDummyDevice [
	^ false
]

{ #category : #'multi eye rendering' }
WDCAbstractVRSystem >> leftEyeProjectionMatrixNear: near far: far invertedY: invertedY [
	self subclassResponsibility
]

{ #category : #testing }
WDCAbstractVRSystem >> leftEyeRenderTargetExtent [
	self subclassResponsibility
]

{ #category : #'multi eye rendering' }
WDCAbstractVRSystem >> leftEyeTransform [
	^ WMReversibleAffineTransformF identity
]

{ #category : #'multi eye rendering' }
WDCAbstractVRSystem >> rightEyeProjectionMatrixNear: near far: far invertedY: invertedY [
	self subclassResponsibility
]

{ #category : #testing }
WDCAbstractVRSystem >> rightEyeRenderTargetExtent [
	self subclassResponsibility
]

{ #category : #'multi eye rendering' }
WDCAbstractVRSystem >> rightEyeTransform [
	^ WMReversibleAffineTransformF identity
]
