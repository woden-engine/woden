Class {
	#name : #WDCTessellationEvaluationShaderStage,
	#superclass : #WDCAbstractShaderStage,
	#category : #'WodenEngine-Core-Shaders'
}

{ #category : #accessing }
WDCTessellationEvaluationShaderStage class >> stageName [
	^ #teval
]

{ #category : #'pipeline state building' }
WDCTessellationEvaluationShaderStage >> agpuStageType [
	^ AGPU_TESSELLATION_EVALUATION_SHADER
]
