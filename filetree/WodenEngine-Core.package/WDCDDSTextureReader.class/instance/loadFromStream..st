as yet unclassified
loadFromStream: aBinaryStream
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