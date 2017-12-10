binding
bind: slot storageBuffer: storageBuffer
	self slotAt: slot + 1 put: storageBuffer action: [
		self validHandle bindStorageBuffer: slot storage_buffer: storageBuffer validHandle
	].