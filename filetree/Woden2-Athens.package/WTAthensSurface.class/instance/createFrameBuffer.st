initialization
createFrameBuffer
	| width height device colorBufferDesc colorBufferView depthStencilDesc depthStencilBufferView |
	width := extent x.
	height := extent y.
	device := engine device.
	colorBufferDesc := AGPUTextureDescription new
		type: AGPU_TEXTURE_2D;
		width: width;
		height: height;
		depthOrArraySize: 1;
		miplevels: 1;
		format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM_SRGB;
		flags: AGPU_TEXTURE_FLAG_RENDER_TARGET | AGPU_TEXTURE_FLAG_READED_BACK;
		sample_count: 1.
	colorBuffer := device createTexture: colorBufferDesc.
	
	colorBufferView := AGPUTextureViewDescription new.
	colorBuffer getFullViewDescription: colorBufferView.
	
	depthStencilDesc := AGPUTextureDescription new
		type: AGPU_TEXTURE_2D;
		width: width;
		height: height;
		depthOrArraySize: 1;
		miplevels: 1;
		format: AGPU_TEXTURE_FORMAT_D24_UNORM_S8_UINT;
		flags: AGPU_TEXTURE_FLAG_DEPTH | AGPU_TEXTURE_FLAG_RENDERBUFFER_ONLY;
		sample_count: 1.
	depthStencilBuffer := device createTexture: depthStencilDesc.
	depthStencilBufferView := AGPUTextureViewDescription new.
	depthStencilBuffer getFullViewDescription: depthStencilBufferView.
	
	frameBuffer := device createFrameBuffer: width height: height colorCount: 1 colorViews: colorBufferView depthStencilView: depthStencilBufferView.
	changedData := true.