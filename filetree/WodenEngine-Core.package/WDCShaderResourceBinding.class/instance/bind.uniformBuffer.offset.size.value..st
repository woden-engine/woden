binding
bind: slot uniformBuffer: uniformBuffer offset: offset size: size value: value
	self slotAt: slot + 1 put: value action: [
		self validHandle bindUniformBufferRange: slot uniform_buffer: uniformBuffer validHandle offset: offset size: size
	].