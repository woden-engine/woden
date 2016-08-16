as yet unclassified
initialize
	super initialize.
	PixelFormatDecoderSelector := Dictionary newFromPairs: {
		AGPU_TEXTURE_FORMAT_B5G6R5_UNORM . #decodeBGR565: .
		AGPU_TEXTURE_FORMAT_B8G8R8X8_UNORM . #decodeBGRX8888: .
		AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM . #decodeBGRA8888: .
		
		AGPU_TEXTURE_FORMAT_BC1_UNORM  . #decodeDXT1: .
		AGPU_TEXTURE_FORMAT_BC2_UNORM  . #decodeDXT3: .
		AGPU_TEXTURE_FORMAT_BC3_UNORM  . #decodeDXT5: .
		
	}