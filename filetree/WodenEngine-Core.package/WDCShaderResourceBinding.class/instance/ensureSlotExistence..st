private
ensureSlotExistence: slot
	[ slots size < slot ] whileTrue: [ slots add: nil ]