Class {
	#name : #WDCWaterMeshDeformationState,
	#superclass : #WDCRenderableDeformationState,
	#instVars : [
		'waterStateData',
		'gpuWaterStates'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #accessing }
WDCWaterMeshDeformationState >> clipMapPeriod: clipMapPeriod [
	waterStateData clipMapPeriod: (clipMapPeriod ifNil: [WMVector2F zero])
]

{ #category : #accessing }
WDCWaterMeshDeformationState >> createEngineDependantData [
	super createEngineDependantData.
	gpuWaterStates := (engine resourceCache streamingStorageBufferPoolFor: WDCWaterDeformationStateStructure)
		allocate: renderableStateBindings size.

	renderableStateBindings doWithIndex: [ :bindings :index |
		bindings
			bind: 0 storageBufferElement: (gpuWaterStates at: index)
	]
]

{ #category : #'renderable state' }
WDCWaterMeshDeformationState >> currentGPUWaterStates [
	^ gpuWaterStates at: engine bufferingFrameIndex
]

{ #category : #accessing }
WDCWaterMeshDeformationState >> harmonicAt: index amplitude: amplitude frequency: frequency center: center [
	waterStateData harmonicAt: index put: (
		WDCWaterHarmonic new
		amplitude: amplitude;
		frequency: frequency;
		center: center;
		radial: true asBit
	).
]

{ #category : #accessing }
WDCWaterMeshDeformationState >> harmonicAt: index amplitude: amplitude frequency: frequency direction: direction [
	waterStateData harmonicAt: index put: (
		WDCWaterHarmonic new
		amplitude: amplitude;
		frequency: frequency;
		center: direction;
		radial: false asBit
	).
]

{ #category : #accessing }
WDCWaterMeshDeformationState >> initialize [
	super initialize.
	waterStateData := WDCWaterDeformationStateStructure new.
]

{ #category : #testing }
WDCWaterMeshDeformationState >> isWaterDeformationState [
	^ true
]

{ #category : #accessing }
WDCWaterMeshDeformationState >> requiresAccessFromTheCPU [
	^ true
]

{ #category : #'renderable state' }
WDCWaterMeshDeformationState >> updateCommonGpuStateForFrame: frameIndex [
	self currentGPUWaterStates value: waterStateData
]

{ #category : #accessing }
WDCWaterMeshDeformationState >> waterStateData [
	^ waterStateData
]
