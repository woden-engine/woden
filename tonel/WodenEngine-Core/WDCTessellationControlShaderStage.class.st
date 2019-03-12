Class {
	#name : #WDCTessellationControlShaderStage,
	#superclass : #WDCAbstractShaderStage,
	#category : #'WodenEngine-Core-Shaders'
}

{ #category : #accessing }
WDCTessellationControlShaderStage class >> stageName [
	^ #tcontrol
]

{ #category : #'pipeline state building' }
WDCTessellationControlShaderStage >> agpuStageType [
	^ AGPU_TESSELLATION_CONTROL_SHADER
]
