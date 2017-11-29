drawing
blitTexture: texture toScreen: aCanvas
	| pitch slicePitch |
	"texture readTextureLevel: 0 arrayIndex: 0 pitch: mainFramebufferForm width * 4 slicePitch: 0 data: mainFramebufferForm bits."
	pitch := mainFramebufferForm width * 4.
	slicePitch := pitch * mainFramebufferForm height.
	mainFramebufferForm unhibernate.
	
	texture readTextureData: 0 arrayIndex: 0 pitch: pitch slicePitch: slicePitch buffer: mainFramebufferForm bits.
	aCanvas translucentImage: mainFramebufferForm at: self bounds origin.