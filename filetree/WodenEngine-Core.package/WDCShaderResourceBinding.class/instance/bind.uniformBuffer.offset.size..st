binding
bind: slot uniformBuffer: uniformBuffer offset: offset size: size
	self slotAt: slot + 1 put: [
		self validHandle bindUniformBufferRange: slot uniform_buffer: uniformBuffer validHandle offset: offset size: size
	].