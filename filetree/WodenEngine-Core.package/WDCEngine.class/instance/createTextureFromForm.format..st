resource building
createTextureFromForm: aForm format: aTextureFormat
	| width height description |
	width := aForm width.
	height := aForm height.
	description := AGPUTextureDescription new
		type: AGPU_TEXTURE_2D;
		format: aTextureFormat;
		width: width;
		height: height;
		depthOrArraySize: 1;
		miplevels: 1;
		sample_count: 1;
		sample_quality: 0;
		flags: AGPU_TEXTURE_FLAG_UPLOADED;
		yourself.
	^ (WDCTexture for: self)
		description: description; 
		data: aForm;
		checkSession;
		yourself.