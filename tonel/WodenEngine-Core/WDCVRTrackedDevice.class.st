Class {
	#name : #WDCVRTrackedDevice,
	#superclass : #Object,
	#instVars : [
		'id',
		'currentPose',
		'currentRenderPose',
		'eventHandler'
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
WDCVRTrackedDevice >> eventHandler [
	^ eventHandler
]

{ #category : #accessing }
WDCVRTrackedDevice >> eventHandler: anObject [
	eventHandler := anObject
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
WDCVRTrackedDevice >> isController [
	^ false
]

{ #category : #testing }
WDCVRTrackedDevice >> isDisplayRedirect [
	^ false
]

{ #category : #testing }
WDCVRTrackedDevice >> isGenericTracker [
	^ false
]

{ #category : #testing }
WDCVRTrackedDevice >> isHeadMountedDisplay [
	^ false
]

{ #category : #testing }
WDCVRTrackedDevice >> isInvalid [
	^ false
]

{ #category : #testing }
WDCVRTrackedDevice >> isTrackingReference [
	^ false
]

{ #category : #'as yet unclassified' }
WDCVRTrackedDevice >> processAndDispatchEvent: agpuVREvent [
	| convertedEvent |
	convertedEvent := WDCVREvent convertFromAGPU: agpuVREvent.
	convertedEvent ifNil: [ ^ self ].
	convertedEvent sourceDevice: self.
	eventHandler ifNotNil: [ eventHandler processVREvent: convertedEvent ]
]
