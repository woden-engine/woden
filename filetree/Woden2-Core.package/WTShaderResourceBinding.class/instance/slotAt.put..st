binding
slotAt: slot put: aBlock
	self ensureSlotExistence: slot.
	slots at: slot put: aBlock.
	self hasValidHandle ifTrue: [ aBlock value ]