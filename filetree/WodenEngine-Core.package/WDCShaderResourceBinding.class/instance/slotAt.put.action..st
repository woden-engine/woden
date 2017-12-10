accessing
slotAt: slot put: value action: aBlock
	slots at: slot put: value.
	slotActions at: slot put: aBlock.
	self hasValidHandle ifTrue: [ aBlock value ]