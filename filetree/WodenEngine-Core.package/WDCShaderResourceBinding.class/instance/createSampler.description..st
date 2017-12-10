binding
createSampler: slot description: description
	self slotAt: slot + 1 put: description action: [
		self validHandle createSampler: slot description: description
	].