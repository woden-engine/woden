initialization
start
	started ifTrue: [ ^ self ].
	started := true.
	engine addRenderProcess: self.
