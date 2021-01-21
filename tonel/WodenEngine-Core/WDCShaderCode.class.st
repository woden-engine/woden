Class {
	#name : #WDCShaderCode,
	#superclass : #Object,
	#instVars : [
		'data',
		'entryPoints'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Shaders'
}

{ #category : #testing }
WDCShaderCode >> applySourceToShaderHandle: shaderHandle [
	shaderHandle setShaderSource: AGPU_SHADER_LANGUAGE_SPIR_V sourceText: data sourceTextLength: data size
]

{ #category : #accessing }
WDCShaderCode >> data [

	^ data
]

{ #category : #accessing }
WDCShaderCode >> data: anObject [

	data := anObject
]

{ #category : #accessing }
WDCShaderCode >> entryPoints [

	^ entryPoints
]

{ #category : #accessing }
WDCShaderCode >> entryPoints: anObject [

	entryPoints := anObject
]

{ #category : #testing }
WDCShaderCode >> isMultiShaderSource [
	^ false
]
