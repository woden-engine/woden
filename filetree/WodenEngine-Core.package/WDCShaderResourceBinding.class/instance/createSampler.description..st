binding
createSampler: slot description: description
	self slotAt: slot + 1 put: [
		self validHandle createSampler: slot description: description
	].