Class {
	#name : #WDCVRState,
	#superclass : #SysmelStructureType,
	#instVars : [
		'#compositionState => WDCCompositionState',
		'#leftProjectionTransform => Float32x4',
		'#leftUndistortedProjectionInverseTransform => Float32x4',
		'#rightProjectionTransform => Float32x4',
		'#rightUndistortedProjectionInverseTransform => Float32x4',
		'#distortionCoefficients => Float32x2',
		'#ipd => Float32'
	],
	#category : #'WodenEngine-NativeStructures-Core-Camera'
}

{ #category : #accessing }
WDCVRState >> compositionState [
	^ compositionState
]

{ #category : #accessing }
WDCVRState >> compositionState: anObject [
	compositionState := anObject
]

{ #category : #accessing }
WDCVRState >> distortionCoefficients [
	^ distortionCoefficients
]

{ #category : #accessing }
WDCVRState >> distortionCoefficients: anObject [
	distortionCoefficients := anObject
]

{ #category : #accessing }
WDCVRState >> ipd [
	^ ipd
]

{ #category : #accessing }
WDCVRState >> ipd: anObject [
	ipd := anObject
]

{ #category : #accessing }
WDCVRState >> leftProjectionTransform [
	^ leftProjectionTransform
]

{ #category : #accessing }
WDCVRState >> leftProjectionTransform: anObject [
	leftProjectionTransform := anObject
]

{ #category : #accessing }
WDCVRState >> leftUndistortedProjectionInverseTransform [
	^ leftUndistortedProjectionInverseTransform
]

{ #category : #accessing }
WDCVRState >> leftUndistortedProjectionInverseTransform: anObject [
	leftUndistortedProjectionInverseTransform := anObject
]

{ #category : #accessing }
WDCVRState >> rightProjectionTransform [
	^ rightProjectionTransform
]

{ #category : #accessing }
WDCVRState >> rightProjectionTransform: anObject [
	rightProjectionTransform := anObject
]

{ #category : #accessing }
WDCVRState >> rightUndistortedProjectionInverseTransform [
	^ rightUndistortedProjectionInverseTransform
]

{ #category : #accessing }
WDCVRState >> rightUndistortedProjectionInverseTransform: anObject [
	rightUndistortedProjectionInverseTransform := anObject
]
