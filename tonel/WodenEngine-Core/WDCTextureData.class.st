Class {
	#name : #WDCTextureData,
	#superclass : #Object,
	#instVars : [
		'pixelFormat',
		'srgbPixelFormat',
		'width',
		'height',
		'depth',
		'layers',
		'type',
		'miplevels'
	],
	#classVars : [
		'PixelFormatDecoderSelector',
		'ThumbnailSize'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : 'WodenEngine-Core-Texture'
}

{ #category : #'as yet unclassified' }
WDCTextureData class >> initialize [
	super initialize.
	ThumbnailSize := 64.
	PixelFormatDecoderSelector := Dictionary newFromPairs: {
		AGPU_TEXTURE_FORMAT_B5G6R5_UNORM . #decodeBGR565: .
		AGPU_TEXTURE_FORMAT_B8G8R8X8_UNORM . #decodeBGRX8888: .
		AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM . #decodeBGRA8888: .
		
		AGPU_TEXTURE_FORMAT_BC1_UNORM  . #decodeDXT1: .
		AGPU_TEXTURE_FORMAT_BC2_UNORM  . #decodeDXT3: .
		AGPU_TEXTURE_FORMAT_BC3_UNORM  . #decodeDXT5: .
	}
	
]

{ #category : #converting }
WDCTextureData >> asSRGBTextureFor: anEngine [
	| description |
	description := AGPUTextureDescription new
		type: type;
		format: srgbPixelFormat;
		width: width;
		height: height;
		depthOrArraySize: depth;
		miplevels: miplevels;
		sample_count: 1;
		sample_quality: 0;
		flags: AGPU_TEXTURE_FLAG_UPLOADED;
		yourself.
	^ (WDCTexture for: anEngine)
			description: description;
			data: self;
			yourself
]

{ #category : #converting }
WDCTextureData >> asTextureFor: anEngine [
	| description |
	description := AGPUTextureDescription new
		type: type;
		format: pixelFormat;
		width: width;
		height: height;
		depthOrArraySize: depth;
		miplevels: miplevels;
		sample_count: 1;
		sample_quality: 0;
		flags: AGPU_TEXTURE_FLAG_UPLOADED;
		yourself.
	^ (WDCTexture for: anEngine)
			description: description;
			data: self;
			yourself
]

{ #category : #converting }
WDCTextureData >> convertLevelToForm: level [
	| selector |
	selector := PixelFormatDecoderSelector at: pixelFormat.
	^ self perform: selector with: level
]

{ #category : #converting }
WDCTextureData >> convertToFormLayer: layerIndex level: levelIndex [
	^ self convertLevelToForm: ((layers at: layerIndex) levels at: levelIndex)
]

{ #category : #converting }
WDCTextureData >> decodeDXT1: level [
	| levelWidth levelHeight resultBuffer result rowSize levelData numberOfRows destRow destBase srcRow srcIndex lookupColors levelPitch c0 c1 c0r c0g c0b c1r c1g c1b rowOffset value lookupIndex rowPitch |
	levelWidth := level width.
	levelHeight := level height.
	levelData := level data.
	levelPitch := levelWidth * 4.
	resultBuffer := ByteArray new: levelPitch*levelHeight.
	rowSize := (levelWidth + 3) // 4.
	rowPitch := rowSize *8.
	numberOfRows := (levelHeight + 3) // 4.

	lookupColors := ByteArray new: 16.
	
	destRow := 1.
	srcRow := 1.
	1 to: numberOfRows do: [ :r |
		destBase := destRow.
		srcIndex := srcRow.
		1 to: rowSize do: [ :c |
			c0 := ((levelData at: srcIndex)) | ((levelData at: srcIndex + 1) << 8).
			c1 := ((levelData at: srcIndex + 2)) | (((levelData at: srcIndex + 3)) << 8).
			srcIndex := srcIndex + 4.

			c0r := ((c0 >> 11) bitAnd: 31) << 3.
			c0g := ((c0 >> 5) bitAnd: 63) << 2.
			c0b := (c0 bitAnd: 31) << 3.

			lookupColors at: 1 put: c0b.
			lookupColors at: 2 put: c0g.
			lookupColors at: 3 put: c0r.
			lookupColors at: 4 put: 255.

			c1r := ((c1 >> 11) bitAnd: 31)<<3.
			c1g := ((c1 >> 5) bitAnd: 63)<<2.
			c1b := (c1 bitAnd: 31)<<3.

			lookupColors at: 5 put: c1b.
			lookupColors at: 6 put: c1g.
			lookupColors at: 7 put: c1r.
			lookupColors at: 8 put: 255.
			
			c0 > c1 ifTrue: [
				lookupColors at: 9 put: (2*c0b + c1b) // 3.
				lookupColors at: 10 put: (2*c0g + c1g) // 3.
				lookupColors at: 11 put: (2*c0r + c1r) // 3.
				lookupColors at: 12 put: 255.

				lookupColors at: 13 put: (2*c1b + c0b) // 3.
				lookupColors at: 14 put: (2*c1g + c0g) // 3.
				lookupColors at: 15 put: (2*c1r + c0r) // 3.
				lookupColors at: 16 put: 255.
			] ifFalse: [
				lookupColors at: 9 put: (c0b + c1b) // 2.
				lookupColors at: 10 put: (c0g + c1g) // 2.
				lookupColors at: 11 put: (c0r + c1r) // 2.
				lookupColors at: 12 put: 255.

				lookupColors at: 13 put: 0.
				lookupColors at: 14 put: 0.
				lookupColors at: 15 put: 0.
				lookupColors at: 16 put: 255.
			].
				
"			lookupColors atAllPut: 0.
			1 to: 4 do: [:i | lookupColors at: i*4 put: 255 ]."
			
			rowOffset := 0.
			1 to: 4 do: [:i |
				value := levelData at: srcIndex.
				0 to: 3 do: [ :j |
					lookupIndex := (value bitAnd: 3) * 4 + 1.
					resultBuffer at: destBase + rowOffset + (j*4) put: (lookupColors at: lookupIndex).
					resultBuffer at: destBase + rowOffset + (j*4) + 1 put: (lookupColors at: lookupIndex + 1).
					resultBuffer at: destBase + rowOffset + (j*4) + 2 put: (lookupColors at: lookupIndex + 2).
					resultBuffer at: destBase + rowOffset + (j*4) + 3 put: (lookupColors at: lookupIndex + 3).
					value := value >> 2.
				].
			
				rowOffset := rowOffset + levelPitch.
				srcIndex := srcIndex + 1
			].

			destBase := destBase + 16
		].
	
		destRow := destRow + (levelPitch * 4).
		srcRow := srcRow + rowPitch.
	].
	
	result := Form extent: levelWidth @ levelHeight depth: 32.
	result unhibernate.
	LibC memCopy: resultBuffer to: result bits size: resultBuffer size.
	^ result
]

{ #category : #converting }
WDCTextureData >> decodeDXT5: level [
	| levelWidth levelHeight resultBuffer result rowSize levelData numberOfRows destRow destBase srcRow srcIndex lookupColors levelPitch c0 c1 c0r c0g c0b c1r c1g c1b rowOffset value lookupIndex rowPitch lookupAlpha a0 a1 alphaData |
	levelWidth := level width.
	levelHeight := level height.
	levelData := level data.
	levelPitch := levelWidth * 4.
	resultBuffer := ByteArray new: levelPitch*levelHeight.
	rowSize := (levelWidth + 3) // 4.
	rowPitch := rowSize *16.
	numberOfRows := (levelHeight + 3) // 4.

	lookupAlpha := ByteArray new: 8.
	lookupColors := ByteArray new: 16.
	
	destRow := 1.
	srcRow := 1.
	1 to: numberOfRows do: [ :r |
		destBase := destRow.
		srcIndex := srcRow.
		1 to: rowSize do: [ :c |
			"Alpha data"
			a0 := levelData at: srcIndex.
			a1 := levelData at: srcIndex + 1.
			lookupAlpha at: 1 put: a0.
			lookupAlpha at: 2 put: a1.
			a0 > a1 ifTrue: [ 
				lookupAlpha at: 3 put: ((6*a0) + a1) // 7.
				lookupAlpha at: 4 put: ((5*a0) + (2*a1)) // 7.
				lookupAlpha at: 5 put: ((4*a0) + (3*a1)) // 7.
				lookupAlpha at: 6 put: ((3*a0) + (4*a1)) // 7.
				lookupAlpha at: 7 put: ((2*a0) + (5*a1)) // 7.
				lookupAlpha at: 8 put: ((a0) + (6*a1)) // 7.
			] ifFalse: [ 
				lookupAlpha at: 3 put: ((4*a0) + a1) // 5.
				lookupAlpha at: 4 put: ((3*a0) + (2*a1)) // 5.
				lookupAlpha at: 5 put: ((2*a0) + (3*a1)) // 5.
				lookupAlpha at: 6 put: ((a0) + (4*a1)) // 5.
				lookupAlpha at: 7 put: 0.
				lookupAlpha at: 8 put: 255.
			].
			
			alphaData := (levelData at: srcIndex + 2) |
				((levelData at: srcIndex + 3) << 8) |
				((levelData at: srcIndex + 4) << 16) |
				((levelData at: srcIndex + 5) << 24) |
				((levelData at: srcIndex + 6) << 32) |
				((levelData at: srcIndex + 7) << 40).

			rowOffset := 0.
			1 to: 4 do: [:i |
				0 to: 3 do: [ :j |
					lookupIndex := (alphaData bitAnd: 7) + 1.
					resultBuffer at: destBase + rowOffset + (j*4) + 3 put: (lookupAlpha at: lookupIndex).
					alphaData := alphaData >> 3.
				].
			
				rowOffset := rowOffset + levelPitch.
			].
						
			srcIndex := srcIndex + 8.
				
			"Color data"
			c0 := ((levelData at: srcIndex)) | ((levelData at: srcIndex + 1) << 8).
			c1 := ((levelData at: srcIndex + 2)) | (((levelData at: srcIndex + 3)) << 8).
			srcIndex := srcIndex + 4.

			c0r := ((c0 >> 11) bitAnd: 31) << 3.
			c0g := ((c0 >> 5) bitAnd: 63) << 2.
			c0b := (c0 bitAnd: 31) << 3.

			lookupColors at: 1 put: c0b.
			lookupColors at: 2 put: c0g.
			lookupColors at: 3 put: c0r.
			lookupColors at: 4 put: 255.

			c1r := ((c1 >> 11) bitAnd: 31)<<3.
			c1g := ((c1 >> 5) bitAnd: 63)<<2.
			c1b := (c1 bitAnd: 31)<<3.

			lookupColors at: 5 put: c1b.
			lookupColors at: 6 put: c1g.
			lookupColors at: 7 put: c1r.
			"lookupColors at: 8 put: 255."
			
			c0 > c1 ifTrue: [
				lookupColors at: 9 put: (2*c0b + c1b) // 3.
				lookupColors at: 10 put: (2*c0g + c1g) // 3.
				lookupColors at: 11 put: (2*c0r + c1r) // 3.
				"lookupColors at: 12 put: 255."

				lookupColors at: 13 put: (2*c1b + c0b) // 3.
				lookupColors at: 14 put: (2*c1g + c0g) // 3.
				lookupColors at: 15 put: (2*c1r + c0r) // 3.
				"lookupColors at: 16 put: 255."
			] ifFalse: [
				lookupColors at: 9 put: (c0b + c1b) // 2.
				lookupColors at: 10 put: (c0g + c1g) // 2.
				lookupColors at: 11 put: (c0r + c1r) // 2.
				"lookupColors at: 12 put: 255."

				lookupColors at: 13 put: 0.
				lookupColors at: 14 put: 0.
				lookupColors at: 15 put: 0.
				"lookupColors at: 16 put: 255."
			].
			
			rowOffset := 0.
			1 to: 4 do: [:i |
				value := levelData at: srcIndex.
				0 to: 3 do: [ :j |
					lookupIndex := (value bitAnd: 3) * 4 + 1.
					resultBuffer at: destBase + rowOffset + (j*4) put: (lookupColors at: lookupIndex).
					resultBuffer at: destBase + rowOffset + (j*4) + 1 put: (lookupColors at: lookupIndex + 1).
					resultBuffer at: destBase + rowOffset + (j*4) + 2 put: (lookupColors at: lookupIndex + 2).
					"resultBuffer at: destBase + rowOffset + (j*4) + 3 put: (lookupColors at: lookupIndex + 3)."
					value := value >> 2.
				].
			
				rowOffset := rowOffset + levelPitch.
				srcIndex := srcIndex + 1
			].

			destBase := destBase + 16
		].
	
		destRow := destRow + (levelPitch * 4).
		srcRow := srcRow + rowPitch.
	].
	
	result := Form extent: levelWidth @ levelHeight depth: 32.
	result unhibernate.
	LibC memCopy: resultBuffer to: result bits size: resultBuffer size.
	^ result
]

{ #category : #accessing }
WDCTextureData >> depth [
	^ depth
]

{ #category : #accessing }
WDCTextureData >> depth: anObject [
	depth := anObject
]

{ #category : #converting }
WDCTextureData >> encodeR5: r G6: g B5: b [
	^ ((r bitAnd: 31) << 11) | ((g bitAnd: 63) << 11) | (b bitAnd: 31)
]

{ #category : #converting }
WDCTextureData >> firstLayerLevelAsForm [
	^ self convertToFormLayer: 1 level: 1
]

{ #category : #accessing }
WDCTextureData >> height [
	^ height
]

{ #category : #accessing }
WDCTextureData >> height: anObject [
	height := anObject
]

{ #category : #accessing }
WDCTextureData >> layers [
	^ layers
]

{ #category : #accessing }
WDCTextureData >> layers: anObject [
	layers := anObject
]

{ #category : #accessing }
WDCTextureData >> miplevels [
	^ miplevels
]

{ #category : #accessing }
WDCTextureData >> miplevels: anObject [
	miplevels := anObject
]

{ #category : #accessing }
WDCTextureData >> pixelFormat [
	^ pixelFormat
]

{ #category : #accessing }
WDCTextureData >> pixelFormat: anObject [
	pixelFormat := anObject
]

{ #category : #accessing }
WDCTextureData >> srgbPixelFormat [
	^ srgbPixelFormat
]

{ #category : #accessing }
WDCTextureData >> srgbPixelFormat: anObject [
	srgbPixelFormat := anObject
]

{ #category : #'as yet unclassified' }
WDCTextureData >> thumbnail [
	| bestLevel levelWidth levelHeight scale |
	bestLevel := 1.
	levelWidth := width.
	levelHeight := height.
	[ levelWidth > ThumbnailSize or: [ levelHeight > ThumbnailSize ] ] whileTrue: [
		levelWidth := levelWidth // 2.
		levelHeight := levelHeight // 2.
		bestLevel := bestLevel + 1
	].

	bestLevel <= miplevels ifTrue: [
		^ self convertToFormLayer: 1 level: bestLevel
	].

	scale := ThumbnailSize / (width max: height).
	^ self firstLayerLevelAsForm scaledToSize: ((width*scale min: ThumbnailSize) asInteger @ (height *scale min: ThumbnailSize) asInteger)
]

{ #category : #accessing }
WDCTextureData >> type [
	^ type
]

{ #category : #accessing }
WDCTextureData >> type: anObject [
	type := anObject
]

{ #category : #accessing }
WDCTextureData >> width [
	^ width
]

{ #category : #accessing }
WDCTextureData >> width: anObject [
	width := anObject
]
