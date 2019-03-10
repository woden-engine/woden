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
	
	deviceToAbsoluteTransform := WMReversibleAffineTransformF identity.
	linearVelocity := WMVector3F zero.
	angularVelocity := WMVector3F zero.
]

{ #category : #accessing }
WDCVRTrackedDevicePose >> linearVelocity [
	^ linearVelocity
]

{ #category : #accessing }
WDCVRTrackedDevicePose >> linearVelocity: anObject [
	linearVelocity := anObject
]
