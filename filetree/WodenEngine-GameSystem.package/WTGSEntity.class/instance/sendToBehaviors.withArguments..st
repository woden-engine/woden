behaviors
sendToBehaviors: selector withArguments: arguments
	(components at: #behavior ifAbsent: [ ^ self ]) do: [ :behavior |
		(behavior respondsTo: selector) ifTrue: [
			behavior perform: selector withArguments: arguments
		]
	]