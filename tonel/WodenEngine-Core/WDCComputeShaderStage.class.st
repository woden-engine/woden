Class {
	#name : #WDCComputeShaderStage,
	#superclass : #WDCAbstractShaderStage,
	#category : #'WodenEngine-Core-Shaders'
}

{ #category : #accessing }
WDCComputeShaderStage class >> stageName [
	^ #compute
]

{ #category : #'pipeline state building' }
WDCComputeShaderStage >> agpuStageType [
	^ AGPU_COMPUTE_SHADER
]

{ #category : #accessing }
WDCComputeShaderStage >> localSizeX [
	^ self propertyAt: #localSizeX ifAbsent: 1
]

{ #category : #accessing }
WDCComputeShaderStage >> localSizeY [
	^ self propertyAt: #localSizeY ifAbsent: 1
]

{ #category : #accessing }
WDCComputeShaderStage >> localSizeZ [
	^ self propertyAt: #localSizeZ ifAbsent: 1
]
