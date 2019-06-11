Class {
	#name : #WDCTextureLevelData,
	#superclass : #Object,
	#instVars : [
		'width',
		'height',
		'depth',
		'pitch',
		'slicePitch',
		'data',
		'valueRange'
	],
	#category : #'WodenEngine-Core-Texture'
}

{ #category : #'cpu rendering' }
WDCTextureLevelData >> colorRenderWith: aBlock [
	| inverseHeight inverseWidth destIndex destRow value |
	inverseHeight := 1.0 / height.
	inverseWidth := 1.0 / height.
	destRow := 1.
	0 to: height - 1 do: [ :y |
		destIndex := destRow.
		0 to: width - 1 do: [ :x |
			value := (aBlock value: (x + 0.5) * inverseWidth value: (y + 0.5) * inverseHeight).
			data at: destIndex put: value blue asNormalizedUByte. destIndex := destIndex + 1.
			data at: destIndex put: value green asNormalizedUByte. destIndex := destIndex + 1.
			data at: destIndex put: value red asNormalizedUByte. destIndex := destIndex + 1.
			data at: destIndex put: value alpha asNormalizedUByte. destIndex := destIndex + 1.
		].
	
		destRow := destRow + pitch
	]
]

{ #category : #accessing }
WDCTextureLevelData >> data [
	^ data
]

{ #category : #accessing }
WDCTextureLevelData >> data: anObject [
	data := anObject.
	valueRange := nil
]

{ #category : #'as yet unclassified' }
WDCTextureLevelData >> decodedNormalData [
	| pixelCount pixelIndex x y z result |
	pixelCount := slicePitch // 4.
	pixelIndex := 1.
	result := ByteArray new: data size.
	1 to: pixelCount do: [ :i |
		x := data at: pixelIndex + 3.
		y := data at: pixelIndex + 1.
		z := data at: pixelIndex.

		result at: pixelIndex put: z.
		result at: pixelIndex + 1 put: y.
		result at: pixelIndex + 2 put: x.
		result at: pixelIndex + 3 put: 255.
		pixelIndex := pixelIndex + 4
	].

	^ result

]

{ #category : #accessing }
WDCTextureLevelData >> depth [
	^ depth
]

{ #category : #accessing }
WDCTextureLevelData >> depth: anObject [
	depth := anObject
]

{ #category : #'cpu rendering' }
WDCTextureLevelData >> grayRenderWith: aBlock [
	| inverseHeight inverseWidth destIndex destRow value |
	inverseHeight := 1.0 / height.
	inverseWidth := 1.0 / height.
	destRow := 1.
	0 to: height - 1 do: [ :y |
		destIndex := destRow.
		0 to: width - 1 do: [ :x |
			value := (aBlock cull: (x + 0.5) * inverseWidth cull: (y + 0.5) * inverseHeight cull: width cull: height) encodeSRGBComponent asNormalizedUByte.
			data at: destIndex put: value.
			destIndex := destIndex + 1
		].
	
		destRow := destRow + pitch
	]
]

{ #category : #accessing }
WDCTextureLevelData >> height [
	^ height
]

{ #category : #accessing }
WDCTextureLevelData >> height: anObject [
	height := anObject
]

{ #category : #'as yet unclassified' }
WDCTextureLevelData >> mipDownSampleLoopInto: target pixelSize: pixelSize with: aBlock [
	| sourceData targetData targetPitch targetWidth targetHeight sourceRowIndex destRowIndex sourceIndex destIndex sourceTopLeft sourceTopRight sourceBottomLeft sourceBottomRight |
	sourceData := data.
	targetData := target data.
	targetPitch := target pitch.
	targetWidth := target width.
	targetHeight := target height.

	sourceRowIndex := 1.
	destRowIndex := 1.
	1 to: targetHeight do: [ :y |
		sourceIndex := sourceRowIndex.
		destIndex := destRowIndex.
		1 to: targetWidth do: [ :x |
			sourceTopLeft := sourceIndex.
			sourceTopRight := sourceIndex + pixelSize.
			sourceBottomLeft := sourceIndex + pitch.
			sourceBottomRight := sourceIndex + pixelSize + pitch.
			
			aBlock value: sourceData value: targetData
				value: {sourceTopLeft . sourceTopRight . sourceBottomLeft . sourceBottomRight}
				value: destIndex.
			
			sourceIndex := sourceIndex + pixelSize + pixelSize.
			destIndex := destIndex + pixelSize.
		].

		sourceRowIndex := sourceRowIndex + pitch + pitch.
		destRowIndex := destRowIndex + targetPitch.
	].	

]

{ #category : #accessing }
WDCTextureLevelData >> pitch [
	^ pitch
]

{ #category : #accessing }
WDCTextureLevelData >> pitch: anObject [
	pitch := anObject
]

{ #category : #'as yet unclassified' }
WDCTextureLevelData >> pixelCount [
	^ width * height * depth
]

{ #category : #'cpu rendering' }
WDCTextureLevelData >> r16RenderWith: aBlock [
	| inverseHeight inverseWidth destIndex destRow value |
	inverseHeight := 1.0 / height.
	inverseWidth := 1.0 / height.
	destRow := 1.
	0 to: height - 1 do: [ :y |
		destIndex := destRow.
		0 to: width - 1 do: [ :x |
			value := (aBlock cull: (x + 0.5) * inverseWidth cull: (y + 0.5) * inverseHeight cull: width cull: height) asNormalizedUShort.
			data unsignedShortAt: destIndex put: value.
			destIndex := destIndex + 2
		].
	
		destRow := destRow + pitch
	]
]

{ #category : #'cpu rendering' }
WDCTextureLevelData >> rRenderWith: aBlock [
	| inverseHeight inverseWidth destIndex destRow value |
	inverseHeight := 1.0 / height.
	inverseWidth := 1.0 / height.
	destRow := 1.
	0 to: height - 1 do: [ :y |
		destIndex := destRow.
		0 to: width - 1 do: [ :x |
			value := (aBlock cull: (x + 0.5) * inverseWidth cull: (y + 0.5) * inverseHeight cull: width cull: height) asNormalizedUByte.
			data at: destIndex put: value.
			destIndex := destIndex + 1
		].
	
		destRow := destRow + pitch
	]
]

{ #category : #'as yet unclassified' }
WDCTextureLevelData >> readDataFromPointer: pointer [
	LibC memCopy: pointer to: data size: data size.
	^ pointer + data size

]

{ #category : #'cpu rendering' }
WDCTextureLevelData >> rgRenderWith: aBlock [
	| inverseHeight inverseWidth destIndex destRow rg |
	inverseHeight := 1.0 / height.
	inverseWidth := 1.0 / height.
	destRow := 1.
	0 to: height - 1 do: [ :y |
		destIndex := destRow.
		0 to: width - 1 do: [ :x |
			rg := aBlock value: (x + 0.5) * inverseWidth value: (y + 0.5) * inverseHeight.

			data at: destIndex put: rg x asNormalizedUByte.
			destIndex := destIndex + 1.

			data at: destIndex put: rg y asNormalizedUByte.
			destIndex := destIndex + 1.
		].
	
		destRow := destRow + pitch
	]
]

{ #category : #'as yet unclassified' }
WDCTextureLevelData >> shortValueRange [
	| max min sourceIndex value |
	valueRange ifNotNil: [ ^ valueRange ].

	max := Float negativeInfinity.
	min := Float infinity.
	sourceIndex := 1.
	1 to: data size // 2 do: [ :i |
		value := data signedShortAt: sourceIndex. sourceIndex := sourceIndex + 2.
		max := max max: value.
		min := min min: value.
	].

	^ valueRange := { min . max }
]

{ #category : #'cpu rendering' }
WDCTextureLevelData >> signedR16RenderWith: aBlock [
	| inverseHeight inverseWidth destIndex destRow value |
	inverseHeight := 1.0 / height.
	inverseWidth := 1.0 / height.
	destRow := 1.
	0 to: height - 1 do: [ :y |
		destIndex := destRow.
		0 to: width - 1 do: [ :x |
			value := (aBlock cull: (x + 0.5) * inverseWidth cull: (y + 0.5) * inverseHeight cull: width cull: height) asNormalizedShort.
			data unsignedShortAt: destIndex put: value.
			destIndex := destIndex + 2
		].
	
		destRow := destRow + pitch
	]
]

{ #category : #accessing }
WDCTextureLevelData >> slicePitch [
	^ slicePitch
]

{ #category : #accessing }
WDCTextureLevelData >> slicePitch: anObject [
	slicePitch := anObject
]

{ #category : #'as yet unclassified' }
WDCTextureLevelData >> swizzleXYZNormalMap [
	| pixelCount pixelIndex x y z |
	pixelCount := slicePitch // 4.
	pixelIndex := 1.
	1 to: pixelCount do: [ :i |
		x := data at: pixelIndex + 2.
		y := data at: pixelIndex + 1.
		z := data at: pixelIndex.

		data at: pixelIndex put: z.
		data at: pixelIndex + 1 put: y.
		data at: pixelIndex + 2 put: 0.
		data at: pixelIndex + 3 put: x.
		pixelIndex := pixelIndex + 4
	]

]

{ #category : #accessing }
WDCTextureLevelData >> width [
	^ width
]

{ #category : #accessing }
WDCTextureLevelData >> width: anObject [
	width := anObject
]
