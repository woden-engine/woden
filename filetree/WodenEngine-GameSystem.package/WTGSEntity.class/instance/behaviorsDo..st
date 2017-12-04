behaviors
behaviorsDo: aBlock
	(components at: #behavior ifAbsent: [ ^ self ]) do: aBlock