Class {
	#name : #WDCTextureLayerData,
	#superclass : #Object,
	#instVars : [
		'width',
		'height',
		'depth',
		'levels'
	],
	#category : 'WodenEngine-Core-Texture'
}

{ #category : #'mipmap computation' }
WDCTextureLayerData >> computMipMaps: aBlock [
	2 to: levels size do: [ :i |
		aBlock value: (levels at: i - 1) value: (levels at: i)
	]
]

{ #category : #'mipmap computation' }
WDCTextureLayerData >> computeMipMaps_R16 [
	self computMipMaps: [ :higher :lower |
		higher mipDownSampleLoopInto: lower pixelSize: 2 with: [ :source :target :sourceIndices :targetIndex |
			| average |
			average := ((source unsignedShortAt: sourceIndices first)  +
				(source unsignedShortAt: sourceIndices second) +
				(source unsignedShortAt: sourceIndices third) +
				(source unsignedShortAt: sourceIndices fourth)) // 4.
			target unsignedShortAt: targetIndex  put: average
		]
	]
]

{ #category : #'mipmap computation' }
WDCTextureLayerData >> computeMipMaps_RG8 [
	self halt
]

{ #category : #'mipmap computation' }
WDCTextureLayerData >> computeMipMaps_RGBA8 [
	self computMipMaps: [ :higher :lower |
		higher mipDownSampleLoopInto: lower pixelSize: 4 with: [ :source :target :sourceIndices :targetIndex |
			| average |
			average := ((source bgraColorAt: sourceIndices first)  +
				(source bgraColorAt: sourceIndices second) +
				(source bgraColorAt: sourceIndices third) +
				(source bgraColorAt: sourceIndices fourth)) / 4.0.
			target bgraColorAt: targetIndex put: average
		]
	]
]

{ #category : #'mipmap computation' }
WDCTextureLayerData >> computeMipMaps_SR16 [
	self computMipMaps: [ :higher :lower |
		higher mipDownSampleLoopInto: lower pixelSize: 2 with: [ :source :target :sourceIndices :targetIndex |
			| average |
			average := ((source signedShortAt: sourceIndices first)  +
				(source signedShortAt: sourceIndices second) +
				(source signedShortAt: sourceIndices third) +
				(source signedShortAt: sourceIndices fourth)) // 4.
			target signedShortAt: targetIndex  put: average
		]
	]
]

{ #category : #'mipmap computation' }
WDCTextureLayerData >> computeMipMaps_gray [
	self computMipMaps: [ :higher :lower |
		higher mipDownSampleLoopInto: lower pixelSize: 1 with: [ :source :target :sourceIndices :targetIndex |
			| average |
			average := ((source at: sourceIndices first) asFloatFromNormalizedUByte decodeSRGBComponent +
				(source at: sourceIndices second) asFloatFromNormalizedUByte decodeSRGBComponent +
				(source at: sourceIndices third) asFloatFromNormalizedUByte decodeSRGBComponent +
				(source at: sourceIndices fourth) asFloatFromNormalizedUByte decodeSRGBComponent) / 4.0.
			target at: targetIndex put: average encodeSRGBComponent asNormalizedUByte
		]
	]
]

{ #category : #'mipmap computation' }
WDCTextureLayerData >> computeMipMaps_sRGB_A8 [
	self computMipMaps: [ :higher :lower |
		higher mipDownSampleLoopInto: lower pixelSize: 4 with: [ :source :target :sourceIndices :targetIndex |
			| average |
			average := ((source sBGR_A_colorAt: sourceIndices first)  +
				(source sBGR_A_colorAt: sourceIndices second) +
				(source sBGR_A_colorAt: sourceIndices third) +
				(source sBGR_A_colorAt: sourceIndices fourth)) / 4.0.
			target sBGR_A_colorAt: targetIndex  put: average
		]
	]
]

{ #category : #accessing }
WDCTextureLayerData >> depth [
	^ depth
]

{ #category : #accessing }
WDCTextureLayerData >> depth: anObject [
	depth := anObject
]

{ #category : #'as yet unclassified' }
WDCTextureLayerData >> generateLevelsWithBpp: bitsPerPixel [
	| levelWidth levelHeight levelDepth pitch slicePitch data |
	levelWidth := width.
	levelHeight := height.
	levelDepth := depth.
	levels := Array streamContents: [ :out |
		[ levelWidth > 0 or: [ levelHeight > 0 or: levelDepth > 0] ] whileTrue: [
			levelWidth := levelWidth max: 1.
			levelHeight := levelHeight max: 1.
			levelDepth := levelDepth max: 1.
		
			pitch := levelWidth * bitsPerPixel / 8 alignedTo: 4.
			slicePitch := pitch * levelHeight.
			data := ByteArray new: slicePitch * levelDepth.
			out nextPut: (WDCTextureLevelData new
					width: levelWidth;
					height: levelHeight;
					depth: levelDepth;
					pitch: pitch;
					slicePitch: slicePitch;
					data: data).
				
			levelWidth := levelWidth // 2.
			levelHeight := levelHeight // 2.
			levelDepth := levelDepth // 2.
		]
	]
]

{ #category : #accessing }
WDCTextureLayerData >> height [
	^ height
]

{ #category : #accessing }
WDCTextureLayerData >> height: anObject [
	height := anObject
]

{ #category : #accessing }
WDCTextureLayerData >> levels [
	^ levels
]

{ #category : #accessing }
WDCTextureLayerData >> levels: anObject [
	levels := anObject
]

{ #category : #accessing }
WDCTextureLayerData >> width [
	^ width
]

{ #category : #accessing }
WDCTextureLayerData >> width: anObject [
	width := anObject
]
