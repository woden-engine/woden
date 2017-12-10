binding
bind: slot storageBuffer: storageBuffer offset: offset size: size value: value
	self slotAt: slot + 1 put: value action: [
		self validHandle bindStorageBufferRange: slot storage_buffer: storageBuffer validHandle offset: offset size: size
	].