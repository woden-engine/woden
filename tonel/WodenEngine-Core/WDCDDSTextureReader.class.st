Class {
	#name : #WDCDDSTextureReader,
	#superclass : #Object,
	#classVars : [
		'DDPF_ALPHA',
		'DDPF_ALPHAPIXELS',
		'DDPF_FOURCC',
		'DDPF_LUMINANCE',
		'DDPF_RGB',
		'DDPF_YUV',
		'DDSCAPS2_CUBEMAP',
		'DDSCAPS2_CUBEMAP_NEGATIVEX',
		'DDSCAPS2_CUBEMAP_NEGATIVEY',
		'DDSCAPS2_CUBEMAP_NEGATIVEZ',
		'DDSCAPS2_CUBEMAP_POSITIVEX',
		'DDSCAPS2_CUBEMAP_POSITIVEY',
		'DDSCAPS2_CUBEMAP_POSITIVEZ',
		'DDSCAPS2_VOLUME',
		'DDSCAPS_COMPLEX',
		'DDSCAPS_MIPMAP',
		'DDSCAPS_TEXTURE',
		'DDSD_CAPS',
		'DDSD_DEPTH',
		'DDSD_HEIGHT',
		'DDSD_LINEARSIZE',
		'DDSD_MIPMAPCOUNT',
		'DDSD_PITCH',
		'DDSD_PIXELFORMAT',
		'DDSD_WIDTH',
		'DDSSignature',
		'DX10',
		'DXT1',
		'DXT2',
		'DXT3',
		'DXT4',
		'DXT5',
		'FourCCDictionary',
		'RXGB'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : 'WodenEngine-Core-Texture'
}

{ #category : #'as yet unclassified' }
WDCDDSTextureReader class >> fourCC: string [
	^ string asByteArray unsignedLongAt: 1
]

{ #category : #'as yet unclassified' }
WDCDDSTextureReader class >> initialize [
	DDSSignature := 'DDS ' asByteArray.
	
	DXT1 := self fourCC: 'DXT1'.
	DXT2 := self fourCC: 'DXT2'.
	DXT3 := self fourCC: 'DXT3'.
	DXT4 := self fourCC: 'DXT4'.
	DXT5 := self fourCC: 'DXT5'.
	DX10 := self fourCC: 'DX10'.
	
	RXGB := self fourCC: 'RXGB'.
	
	DDSD_CAPS := 16r1.
	DDSD_HEIGHT := 16r2.
	DDSD_WIDTH := 16r4.
	DDSD_PITCH := 16r8.
	DDSD_PIXELFORMAT := 16r1000.
	DDSD_MIPMAPCOUNT := 16r20000.
	DDSD_LINEARSIZE := 16r20000.
	DDSD_DEPTH := 16r800000.
	
	DDPF_ALPHAPIXELS := 16r1.
	DDPF_ALPHA := 16r2.
	DDPF_FOURCC := 16r4.
	DDPF_RGB := 16r40.
	DDPF_YUV := 16r200.
	DDPF_LUMINANCE := 16r20000.
	
	DDSCAPS_COMPLEX := 16r8.
	DDSCAPS_MIPMAP := 16r400000.
	DDSCAPS_TEXTURE := 16r1000.
	
	DDSCAPS2_CUBEMAP := 16r200.
	DDSCAPS2_CUBEMAP_POSITIVEX := 16r400.
	DDSCAPS2_CUBEMAP_NEGATIVEX := 16r800.
	DDSCAPS2_CUBEMAP_POSITIVEY := 16r1000.
	DDSCAPS2_CUBEMAP_NEGATIVEY := 16r2000.
	DDSCAPS2_CUBEMAP_POSITIVEZ := 16r4000.
	DDSCAPS2_CUBEMAP_NEGATIVEZ := 16r8000.
	DDSCAPS2_VOLUME := 16r200000.
	
	FourCCDictionary := Dictionary newFromPairs: {
		DXT1 . {8 . AGPU_TEXTURE_FORMAT_BC1_UNORM . AGPU_TEXTURE_FORMAT_BC1_UNORM_SRGB }.
		DXT2 . {16 . AGPU_TEXTURE_FORMAT_BC2_UNORM . AGPU_TEXTURE_FORMAT_BC2_UNORM_SRGB }.
		DXT3 . {16 . AGPU_TEXTURE_FORMAT_BC2_UNORM . AGPU_TEXTURE_FORMAT_BC2_UNORM_SRGB }.
		DXT4 . {16 . AGPU_TEXTURE_FORMAT_BC3_UNORM . AGPU_TEXTURE_FORMAT_BC3_UNORM_SRGB }.
		DXT5 . {16 . AGPU_TEXTURE_FORMAT_BC3_UNORM . AGPU_TEXTURE_FORMAT_BC3_UNORM_SRGB }.
		
		RXGB . {16 . AGPU_TEXTURE_FORMAT_BC3_UNORM . AGPU_TEXTURE_FORMAT_BC3_UNORM_SRGB }.
	}
	
]

{ #category : #'as yet unclassified' }
WDCDDSTextureReader class >> textureFromFileNamed: fileName [
	| stream |
	stream := FileStream readOnlyFileNamed: fileName.
	[
		stream binary.
		^ self textureFromStream: stream
	] ensure: [ stream close ]
]

{ #category : #'as yet unclassified' }
WDCDDSTextureReader class >> textureFromStream: aBinaryStream [
	^ self new loadFromStream: aBinaryStream
]

{ #category : #'as yet unclassified' }
WDCDDSTextureReader >> loadCompressedLayerFromStream: aBinaryStream header: header blockSize: blockSize [
	| formatInfo pitch currentWidth currentHeight rows levelSize mipMapCount mipData mipLevels level width height |
	width := header width.
	height := header width.
	
	currentWidth := width.
	currentHeight := height.
	mipMapCount := header mipMapCount.
	mipLevels := (1 to: mipMapCount) collect: [ :i |
		pitch := ((currentWidth + 3) // 4 max: 1) * blockSize.
		rows := (currentHeight + 3) // 4 max: 1.
		levelSize := pitch * rows.
		
		mipData := aBinaryStream next: levelSize.
		level := WDCTextureLevelData new
			width: currentWidth;
			height: currentHeight;
			depth: 1;
			pitch: pitch;
			slicePitch: levelSize;
			data: mipData;
			yourself.

		
		currentWidth := currentWidth // 2 max: 1.
		currentHeight := currentHeight // 2 max: 1.
		
		level
	].
	
	^ WDCTextureLayerData new
		width: width;
		height: height;
		depth: 1;
		levels: mipLevels
]

{ #category : #'as yet unclassified' }
WDCDDSTextureReader >> loadFromStream: aBinaryStream [
	| header pixelFormat textureData numberOfLayers blockSize compressedFormatInfo |
	(aBinaryStream next: 4) ~= DDSSignature ifTrue: [
		self error: 'Trying to read a DDS file an invalid signature.'
	].
	
	header := WTDDSFileHeader new.
	header readBytesFrom: (aBinaryStream next: WTDDSFileHeader structureSize).
	
	header size ~= WTDDSFileHeader structureSize ifTrue: [ 
		self error: 'DDS file contains an invalid header'.
	].

	pixelFormat := header pixelFormat.
	pixelFormat size ~= WTDDSPixelFormat structureSize ifTrue: [ 
		self error: 'DDS file contains an invalid pixel format header'.
	].

	textureData := WDCTextureData new
		type: AGPU_TEXTURE_2D;
		miplevels: header mipMapCount;
		width: header width;
		height: header height;
		depth: (header depth max: 1).
		
	numberOfLayers := 1.
	(header caps2 anyMask: DDSCAPS2_CUBEMAP) ifTrue: [
		textureData type: AGPU_TEXTURE_CUBE.
		numberOfLayers := 6.
	].

	(pixelFormat flags anyMask: DDPF_FOURCC) ifTrue: [
		compressedFormatInfo := FourCCDictionary at: pixelFormat fourCC.
		blockSize := compressedFormatInfo first.
		textureData
			pixelFormat: compressedFormatInfo second;
			srgbPixelFormat: compressedFormatInfo third.
		
		textureData layers: ((1 to: numberOfLayers) collect: [:i | self loadCompressedLayerFromStream: aBinaryStream header: header blockSize: blockSize ])
	] ifFalse: [ 
		textureData layers: ((1 to: numberOfLayers) collect: [:i | self loadUncompressedLayerFromStream: aBinaryStream header: header format: pixelFormat fourCC ])
	].
	
	^ textureData
]

{ #category : #'as yet unclassified' }
WDCDDSTextureReader >> loadUncompressedLayerFromStream: aBinaryStream header: header format: pixelFormat [
	self halt.
]
