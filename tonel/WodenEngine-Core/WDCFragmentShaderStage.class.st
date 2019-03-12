Class {
	#name : #WDCFragmentShaderStage,
	#superclass : #WDCAbstractShaderStage,
	#category : #'WodenEngine-Core-Shaders'
}

{ #category : #accessing }
WDCFragmentShaderStage class >> stageName [
	^ #fragment
]

{ #category : #'pipeline state building' }
WDCFragmentShaderStage >> agpuStageType [
	^ AGPU_FRAGMENT_SHADER
]
