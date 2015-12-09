initialization
blitTexture: texture toScreen: aCanvas
	texture readTextureLevel: 0 arrayIndex: 0 pitch: mainFramebufferForm width * 4 slicePitch: 0 data: mainFramebufferForm bits.
	aCanvas translucentImage: mainFramebufferForm at: self bounds origin.