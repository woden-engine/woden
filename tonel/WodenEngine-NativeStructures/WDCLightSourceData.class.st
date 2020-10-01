Class {
	#name : #WDCLightSourceData,
	#superclass : #SysmelStructureType,
	#instVars : [
		'#positionOrDirection => Float32x4',
		'#intensity => Float32x4',
		'#spotDirection => Float32x3',
		'#shadowMapLayer => Float32',
		'#innerCosCutoff => Float32',
		'#outerCosCutoff => Float32',
		'#spotExponent => Float32',
		'#radius => Float32',
		'#cascadeSplitOffsets => Float32x4',
		'#cascadeFrustumPlane => Float32x4',
		'#shadowMapTransform => Float32x4x4',
		'#shadowMapTransform2 => Float32x4x4',
		'#shadowMapTransform3 => Float32x4x4'
	],
	#category : #'WodenEngine-NativeStructures-Core-Rendering'
}

{ #category : #accessing }
WDCLightSourceData >> direction: newDirection [
	positionOrDirection := Float32x4 xyz: newDirection w: 0
]

{ #category : #accessing }
WDCLightSourceData >> position: newDirection [
	positionOrDirection := Float32x4 xyz: newDirection w: 1
]
