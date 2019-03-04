Class {
	#name : #WDCAGPUVRSystem,
	#superclass : #WDCAbstractVRSystem,
	#instVars : [
		'handle',
		'recommendedRenderTargetExtent',
		'leftEyeFrustumTangents',
		'rightEyeFrustumTangents',
		'leftEyeTransform',
		'rightEyeTransform'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-VR'
}

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
		top: tangents top negated;
		bottom: tangents bottom negated;
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
