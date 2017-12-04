binding
bind: slot storageBuffer: storageBuffer
	self slotAt: slot + 1 put: [
		self validHandle bindStorageBuffer: slot storage_buffer: storageBuffer validHandle
	].