converting
asSRGBTextureFor: anEngine
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