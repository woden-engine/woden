binding
bind: slot uniformBuffer: uniformBuffer
	self slotAt: slot + 1 put: uniformBuffer action: [
		self validHandle bindUniformBuffer: slot uniform_buffer: uniformBuffer validHandle
	].