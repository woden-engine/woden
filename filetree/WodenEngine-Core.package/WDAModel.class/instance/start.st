initialization
start
	started ifTrue: [ ^ self ].
	engine addRenderProcess: self.
	started := true.