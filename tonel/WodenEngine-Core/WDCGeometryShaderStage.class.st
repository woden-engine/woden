Class {
	#name : #WDCGeometryShaderStage,
	#superclass : #WDCAbstractShaderStage,
	#category : #'WodenEngine-Core-Shaders'
}

{ #category : #accessing }
WDCGeometryShaderStage class >> stageName [
	^ #geometry
]

{ #category : #'pipeline state building' }
WDCGeometryShaderStage >> agpuStageType [
	^ AGPU_GEOMETRY_SHADER
]
