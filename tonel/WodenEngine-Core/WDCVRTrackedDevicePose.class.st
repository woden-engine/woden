Class {
	#name : #WDCVRTrackedDevicePose,
	#superclass : #Object,
	#instVars : [
		'deviceToAbsoluteTransform',
		'linearVelocity',
		'angularVelocity'
	],
	#category : #'WodenEngine-Core-VR'
}

{ #category : #accessing }
WDCVRTrackedDevicePose >> angularVelocity [
	^ angularVelocity
]

{ #category : #accessing }
WDCVRTrackedDevicePose >> angularVelocity: anObject [
	angularVelocity := anObject
]

{ #category : #accessing }
WDCVRTrackedDevicePose >> deviceToAbsoluteTransform [
	^ deviceToAbsoluteTransform
]

{ #category : #accessing }
WDCVRTrackedDevicePose >> deviceToAbsoluteTransform: anObject [
	deviceToAbsoluteTransform := anObject
]

{ #category : #initialization }
WDCVRTrackedDevicePose >> initialize [
	super initialize.
	
	deviceToAbsoluteTransform := ReversibleAffineTransform3dF32 identity.
	linearVelocity := Float32x3 zero.
	angularVelocity := Float32x3 zero.
]

{ #category : #accessing }
WDCVRTrackedDevicePose >> linearVelocity [
	^ linearVelocity
]

{ #category : #accessing }
WDCVRTrackedDevicePose >> linearVelocity: anObject [
	linearVelocity := anObject
]
