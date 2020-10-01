Class {
	#name : #WDCCameraPostProcessingState,
	#superclass : #SysmelStructureType,
	#instVars : [
		'#currentSceneLuminance => Float32'
	],
	#category : #'WodenEngine-NativeStructures-Core-Camera'
}

{ #category : #accessing }
WDCCameraPostProcessingState >> currentSceneLuminance [
	^ currentSceneLuminance
]

{ #category : #accessing }
WDCCameraPostProcessingState >> currentSceneLuminance: anObject [
	currentSceneLuminance := anObject
]
