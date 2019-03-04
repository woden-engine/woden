Class {
	#name : #WDCDummyVRSystem,
	#superclass : #WDCAbstractVRSystem,
	#category : #'WodenEngine-Core-VR'
}

{ #category : #testing }
WDCDummyVRSystem >> hasSupportForVR [
	^ false
]

{ #category : #'multi eye rendering' }
WDCDummyVRSystem >> leftEyeProjectionMatrixNear: near far: far invertedY: invertedY [
	^ WMMatrix4F reverseDepthPerspectiveFovY: 60.0 aspect: 1.0 near: near far: far invertedY: invertedY
]

{ #category : #testing }
WDCDummyVRSystem >> leftEyeRenderTargetExtent [
	^ 512@512
]

{ #category : #'multi eye rendering' }
WDCDummyVRSystem >> rightEyeProjectionMatrixNear: near far: far invertedY: invertedY [
	^ WMMatrix4F reverseDepthPerspectiveFovY: 60.0 aspect: 1.0 near: near far: far invertedY: invertedY
]

{ #category : #testing }
WDCDummyVRSystem >> rightEyeRenderTargetExtent [
	^ 512@512
]
