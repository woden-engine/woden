private
readColorBufferToForm
	| pitch slicePitch |
	pitch := framebufferForm width * 4.
	slicePitch := pitch * framebufferForm height.
	framebufferForm unhibernate.
	synchronizationFence waitOnClient.
	colorBuffer readTextureData: 0 arrayIndex: 0 pitch: pitch slicePitch: slicePitch buffer: framebufferForm bits.
