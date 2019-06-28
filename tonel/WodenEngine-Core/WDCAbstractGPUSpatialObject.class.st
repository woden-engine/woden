Class {
	#name : #WDCAbstractGPUSpatialObject,
	#superclass : #WDCAbstractSpatialObject,
	#instVars : [
		'gpuObjectStates',
		'objectStateBindings'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-SpatialObject'
}

{ #category : #accessing }
WDCAbstractGPUSpatialObject >> currentGpuObjectState [
	^ gpuObjectStates at: engine bufferingFrameIndex
]

{ #category : #accessing }
WDCAbstractGPUSpatialObject >> currentObjectStateBinding [
	^ objectStateBindings at: engine bufferingFrameIndex
]
