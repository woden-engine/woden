private
slotAt: slot put: aBlock
	slots at: slot put: aBlock.
	self hasValidHandle ifTrue: [ aBlock value ]