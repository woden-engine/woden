binding
bind: slot uniformBuffer: uniformBuffer
	self slotAt: slot put: [
		self validHandle bindUniformBuffer: slot uniform_buffer: uniformBuffer validHandle
	].