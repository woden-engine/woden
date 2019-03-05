Class {
	#name : #WDCVRTrackedDevice,
	#superclass : #Object,
	#instVars : [
		'id',
		'currentPose',
		'currentRenderPose'
	],
	#category : #'WodenEngine-Core-VR'
}

{ #category : #accessing }
WDCVRTrackedDevice >> currentPose [
	^ currentPose
]

{ #category : #accessing }
WDCVRTrackedDevice >> currentPose: anObject [
	currentPose := anObject
]

{ #category : #accessing }
WDCVRTrackedDevice >> currentRenderPose [
	^ currentRenderPose
]

{ #category : #accessing }
WDCVRTrackedDevice >> currentRenderPose: anObject [
	currentRenderPose := anObject
]

{ #category : #accessing }
WDCVRTrackedDevice >> id [
	^ id
]

{ #category : #accessing }
WDCVRTrackedDevice >> id: anObject [
	id := anObject
]

{ #category : #initialization }
WDCVRTrackedDevice >> initialize [
	super initialize.
	
	currentPose := WDCVRTrackedDevicePose new.
	currentRenderPose := WDCVRTrackedDevicePose new.
]

{ #category : #testing }
WDCVRTrackedDevice >> isHeadMountedDisplay [
	^ false
]
