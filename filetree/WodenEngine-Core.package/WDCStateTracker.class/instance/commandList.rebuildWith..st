commands
commandList: aCommandList rebuildWith: aBlock
	commandList := aCommandList.
	self reset.
	commandList withPipelineState: nil rebuild: [ :builder |
		commandListBuilder := builder.
		[ 
			aBlock cull: self.
		] ensure: [ commandListBuilder := nil ]
	].
	^ aCommandList