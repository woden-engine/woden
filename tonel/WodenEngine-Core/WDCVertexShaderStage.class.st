Class {
	#name : #WDCVertexShaderStage,
	#superclass : #WDCAbstractShaderStage,
	#category : #'WodenEngine-Core-Shaders'
}

{ #category : #accessing }
WDCVertexShaderStage class >> stageName [
	^ #vertex
]

{ #category : #'pipeline state building' }
WDCVertexShaderStage >> agpuStageType [
	^ AGPU_VERTEX_SHADER
]
