Class {
	#name : #WDCAGPUVRSystem,
	#superclass : #WDCAbstractVRSystem,
	#instVars : [
		'handle',
		'recommendedRenderTargetExtent',
		'leftEyeFrustumTangents',
		'rightEyeFrustumTangents',
		'leftEyeTransform',
		'rightEyeTransform',
		'trackedDevices',
		'hmdTrackedDevice'
	],
	#classVars : [
		'DeviceClassIDToClassMap'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-VR'
}

{ #category : #'class initialization' }
WDCAGPUVRSystem class >> initialize [

	DeviceClassIDToClassMap := Dictionary newFromPairs: { 
		AGPU_VR_TRACKED_DEVICE_CLASS_HMD . WDCVRTrackedDeviceHMD .
		AGPU_VR_TRACKED_DEVICE_CLASS_CONTROLLER . WDCVRTrackedDeviceController .
		AGPU_VR_TRACKED_DEVICE_CLASS_GENERIC_TRACKER . WDCVRTrackedDeviceGenericTracker .
		AGPU_VR_TRACKED_DEVICE_CLASS_TRACKING_REFERENCE . WDCVRTrackedDeviceTrackingReference .
		AGPU_VR_TRACKED_DEVICE_CLASS_DISPLAY_REDIRECT . WDCVRTrackedDeviceDisplayRedirect .
	}
]

{ #category : #wrappers }
WDCAGPUVRSystem >> checkTrackedDevice: oldDevice forPose: trackedDevicePose [
	| requiredClass |
	requiredClass := DeviceClassIDToClassMap at: trackedDevicePose device_class ifAbsent: [ WDCVRTrackedDeviceInvalid ].
	^ oldDevice class == requiredClass
		ifTrue: [ oldDevice ]
		ifFalse: [ self newTrackedDeviceFor: trackedDevicePose ]
]

{ #category : #initialization }
WDCAGPUVRSystem >> convertEyeToHeadTransform: rawEyeMatrix [
	| t |
	t := rawEyeMatrix c4.
	
	^ WMReversibleAffineTransformF identity
		translation: (WMVector3F x: t x y: t y z: t z)
]

{ #category : #initialization }
WDCAGPUVRSystem >> convertFrustumTangents: tangents [
	^ WDCFrustumTangents new
		left: tangents left;
		right: tangents right;
		top: tangents top;
		bottom: tangents bottom;
		yourself
]

{ #category : #wrappers }
WDCAGPUVRSystem >> convertTrackedDevicePose: originalPose [
	^ WDCVRTrackedDevicePose new
		deviceToAbsoluteTransform: originalPose device_to_absolute_tracking asWMReversibleAffineTransformF;
		linearVelocity: originalPose velocity asWMVector3F;
		angularVelocity: originalPose angular_velocity asWMVector3F;
		yourself
]

{ #category : #accessing }
WDCAGPUVRSystem >> handle [
	^ handle
]

{ #category : #testing }
WDCAGPUVRSystem >> hasSupportForVR [
	^ true
]

{ #category : #accessing }
WDCAGPUVRSystem >> hmdTrackedDevice [
	^ hmdTrackedDevice
]

{ #category : #initialization }
WDCAGPUVRSystem >> initialize [
	super initialize.
	trackedDevices := #().
	hmdTrackedDevice := WDCVRTrackedDeviceHMD new.
]

{ #category : #initialization }
WDCAGPUVRSystem >> initializeWithEngine: anEngine [
	| size agpuFrustumTangents rawEyeMatrix |
	super initializeWithEngine: anEngine.
	
	handle := engine device getVRSystem.
	
	"Fetch the recommended render target extent."
	size := AGPUSize2d new.
	handle getRecommendedRenderTargetSize: size.
	recommendedRenderTargetExtent := size width @ size height.
	
	"Fetch the frustum tangents"
	agpuFrustumTangents := AGPUFrustumTangents new.
	handle getProjectionFrustumTangents: AGPU_VR_EYE_LEFT frustum: agpuFrustumTangents.
	leftEyeFrustumTangents := self convertFrustumTangents: agpuFrustumTangents.

	handle getProjectionFrustumTangents: AGPU_VR_EYE_RIGHT frustum: agpuFrustumTangents.
	rightEyeFrustumTangents := self convertFrustumTangents: agpuFrustumTangents.
	
	"Fetch the transforms"
	rawEyeMatrix := AGPUMatrix4x4f new.

	handle getEyeToHeadTransform: AGPU_VR_EYE_LEFT transform: rawEyeMatrix.
	leftEyeTransform := self convertEyeToHeadTransform: rawEyeMatrix.
	
	handle getEyeToHeadTransform: AGPU_VR_EYE_RIGHT transform: rawEyeMatrix.
	rightEyeTransform := self convertEyeToHeadTransform: rawEyeMatrix.

]

{ #category : #'multi eye rendering' }
WDCAGPUVRSystem >> leftEyeProjectionMatrixNear: near far: far invertedY: invertedY [
	^ leftEyeFrustumTangents projectionMatrixNear: near far: far invertedY: invertedY
]

{ #category : #testing }
WDCAGPUVRSystem >> leftEyeRenderTargetExtent [
	^ recommendedRenderTargetExtent
]

{ #category : #'multi eye rendering' }
WDCAGPUVRSystem >> leftEyeTransform [
	^ leftEyeTransform
]

{ #category : #wrappers }
WDCAGPUVRSystem >> newTrackedDeviceFor: trackedDevicePose [
	^ (DeviceClassIDToClassMap at: trackedDevicePose device_class ifAbsent: [ WDCVRTrackedDeviceInvalid ]) new
		id: trackedDevicePose device_id;
		yourself
]

{ #category : #'multi eye rendering' }
WDCAGPUVRSystem >> rightEyeProjectionMatrixNear: near far: far invertedY: invertedY [
	^ rightEyeFrustumTangents projectionMatrixNear: near far: far invertedY: invertedY
]

{ #category : #testing }
WDCAGPUVRSystem >> rightEyeRenderTargetExtent [
	^ recommendedRenderTargetExtent
]

{ #category : #'multi eye rendering' }
WDCAGPUVRSystem >> rightEyeTransform [
	^ rightEyeTransform
]

{ #category : #'as yet unclassified' }
WDCAGPUVRSystem >> submitLeftEye: leftEyeTexture rightEye: rightEyeTexture [
	handle submitEyeRenderTargets: leftEyeTexture validHandle right_eye: rightEyeTexture validHandle
]

{ #category : #accessing }
WDCAGPUVRSystem >> trackedDevices [
	^ trackedDevices
]

{ #category : #wrappers }
WDCAGPUVRSystem >> waitAndFetchPoses [
	| trackedDevicePoseCount trackedDevicePose oldTrackedDevices trackedDeviceRenderPose trackedDevice |
	handle waitAndFetchPoses.
	
	oldTrackedDevices := Dictionary new.
	trackedDevices do: [ :device | oldTrackedDevices at: device id put: device ].

	trackedDevicePoseCount := handle getValidTrackedDevicePoseCount.
	trackedDevicePose := AGPUVrTrackedDevicePose new.
	trackedDeviceRenderPose := AGPUVrTrackedDevicePose new.
	trackedDevices := (1 to: trackedDevicePoseCount) collect: [ :i |
		handle getValidTrackedDevicePoseInto: i - 1 dest: trackedDevicePose.
		handle getValidRenderTrackedDevicePoseInto: i - 1 dest: trackedDeviceRenderPose.
		
		trackedDevice := oldTrackedDevices at: trackedDevicePose device_id
			ifPresent: [ :oldDevice | self checkTrackedDevice: oldDevice forPose: trackedDevicePose ]
			ifAbsent: [ self newTrackedDeviceFor: trackedDevicePose ].
		
		trackedDevice
			currentPose: (self convertTrackedDevicePose: trackedDevicePose);
			currentRenderPose: (self convertTrackedDevicePose: trackedDeviceRenderPose);
			yourself
	].

	trackedDevices detect: #isHeadMountedDisplay ifFound: [ :device | hmdTrackedDevice := device ].
	
	"Transcript show: hmdTrackedDevice currentPose deviceToAbsoluteTransform translation; cr.
	Transcript show: hmdTrackedDevice currentPose deviceToAbsoluteTransform matrix; cr."
]
