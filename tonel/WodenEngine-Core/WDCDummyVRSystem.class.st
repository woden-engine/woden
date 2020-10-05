Class {
	#name : #WDCDummyVRSystem,
	#superclass : #WDCAbstractVRSystem,
	#instVars : [
		'hmdTrackedDevice',
		'trackedDevices'
	],
	#category : #'WodenEngine-Core-VR'
}

{ #category : #testing }
WDCDummyVRSystem >> hasSupportForVR [
	^ false
]

{ #category : #accessing }
WDCDummyVRSystem >> hmdTrackedDevice [
	^ hmdTrackedDevice
]

{ #category : #initialization }
WDCDummyVRSystem >> initialize [
	super initialize.
	
	hmdTrackedDevice := WDCVRTrackedDeviceHMD new id: 0.
	trackedDevices := { hmdTrackedDevice }.
]

{ #category : #'multi eye rendering' }
WDCDummyVRSystem >> leftEyeFrustumNear: near far: far [
	^ FrustumF32 new makePerspectiveFovY: 60.0 aspect: 1.0 near: near far: far
]

{ #category : #'multi eye rendering' }
WDCDummyVRSystem >> leftEyeProjectionMatrixNear: near far: far invertedY: invertedY [
	^ Float32x4x4 reverseDepthPerspectiveFovY: 60.0 aspect: 1.0 near: near far: far invertedY: invertedY
]

{ #category : #testing }
WDCDummyVRSystem >> leftEyeRenderTargetExtent [
	^ 512@512
]

{ #category : #'multi eye rendering' }
WDCDummyVRSystem >> rightEyeFrustumNear: near far: far [
	^ FrustumF32 new makePerspectiveFovY: 60.0 aspect: 1.0 near: near far: far
]

{ #category : #'multi eye rendering' }
WDCDummyVRSystem >> rightEyeProjectionMatrixNear: near far: far invertedY: invertedY [
	^ Float32x4x4 reverseDepthPerspectiveFovY: 60.0 aspect: 1.0 near: near far: far invertedY: invertedY
]

{ #category : #testing }
WDCDummyVRSystem >> rightEyeRenderTargetExtent [
	^ 512@512
]

{ #category : #accessing }
WDCDummyVRSystem >> trackedDevices [
	^ trackedDevices
]
