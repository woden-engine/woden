private
readColorBufferToForm
	| pitch slicePitch |
	pitch := framebufferForm width * 4.
	slicePitch := pitch * framebufferForm height.
	framebufferForm unhibernate.
	self waitFence.
	colorBuffer readTextureData: 0 arrayIndex: 0 pitch: pitch slicePitch: slicePitch buffer: framebufferForm bits.
