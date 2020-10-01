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
WDCLightSourceData >> cascadeFrustumPlane [
	^ cascadeFrustumPlane
]

{ #category : #accessing }
WDCLightSourceData >> cascadeFrustumPlane: anObject [
	cascadeFrustumPlane := anObject
]

{ #category : #accessing }
WDCLightSourceData >> cascadeSplitOffsets [
	^ cascadeSplitOffsets
]

{ #category : #accessing }
WDCLightSourceData >> cascadeSplitOffsets: anObject [
	cascadeSplitOffsets := anObject
]

{ #category : #accessing }
WDCLightSourceData >> direction: newDirection [
	positionOrDirection := Float32x4 xyz: newDirection w: 0
]

{ #category : #accessing }
WDCLightSourceData >> innerCosCutoff [
	^ innerCosCutoff
]

{ #category : #accessing }
WDCLightSourceData >> innerCosCutoff: anObject [
	innerCosCutoff := anObject
]

{ #category : #accessing }
WDCLightSourceData >> intensity [
	^ intensity
]

{ #category : #accessing }
WDCLightSourceData >> intensity: anObject [
	intensity := anObject
]

{ #category : #accessing }
WDCLightSourceData >> outerCosCutoff [
	^ outerCosCutoff
]

{ #category : #accessing }
WDCLightSourceData >> outerCosCutoff: anObject [
	outerCosCutoff := anObject
]

{ #category : #accessing }
WDCLightSourceData >> position: newDirection [
	positionOrDirection := Float32x4 xyz: newDirection w: 1
]

{ #category : #accessing }
WDCLightSourceData >> positionOrDirection [
	^ positionOrDirection
]

{ #category : #accessing }
WDCLightSourceData >> positionOrDirection: anObject [
	positionOrDirection := anObject
]

{ #category : #accessing }
WDCLightSourceData >> radius [
	^ radius
]

{ #category : #accessing }
WDCLightSourceData >> radius: anObject [
	radius := anObject
]

{ #category : #accessing }
WDCLightSourceData >> shadowMapLayer [
	^ shadowMapLayer
]

{ #category : #accessing }
WDCLightSourceData >> shadowMapLayer: anObject [
	shadowMapLayer := anObject
]

{ #category : #accessing }
WDCLightSourceData >> shadowMapTransform [
	^ shadowMapTransform
]

{ #category : #accessing }
WDCLightSourceData >> shadowMapTransform2 [
	^ shadowMapTransform2
]

{ #category : #accessing }
WDCLightSourceData >> shadowMapTransform2: anObject [
	shadowMapTransform2 := anObject
]

{ #category : #accessing }
WDCLightSourceData >> shadowMapTransform3 [
	^ shadowMapTransform3
]

{ #category : #accessing }
WDCLightSourceData >> shadowMapTransform3: anObject [
	shadowMapTransform3 := anObject
]

{ #category : #accessing }
WDCLightSourceData >> shadowMapTransform: anObject [
	shadowMapTransform := anObject
]

{ #category : #accessing }
WDCLightSourceData >> spotDirection [
	^ spotDirection
]

{ #category : #accessing }
WDCLightSourceData >> spotDirection: anObject [
	spotDirection := anObject
]

{ #category : #accessing }
WDCLightSourceData >> spotExponent [
	^ spotExponent
]

{ #category : #accessing }
WDCLightSourceData >> spotExponent: anObject [
	spotExponent := anObject
]
