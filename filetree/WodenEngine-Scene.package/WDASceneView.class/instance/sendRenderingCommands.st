rendering process stages
sendRenderingCommands
	commandList ifNil: [ ^ self ].
	engine graphicsQueue addCommandList: commandList validHandle
		