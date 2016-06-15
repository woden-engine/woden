rendering
renderOn: commandList mode: renderMode
	renderable ifNil: [ ^ self ].
	
	commandList
		useShaderResources: self currentObjectStateBinding validHandle.
		
	renderable renderOn: commandList mode: #forward.