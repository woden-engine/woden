rendering
renderOn: commandList mode: renderMode submode: submode
	renderable ifNil: [ ^ self ].
	
	commandList
		useShaderResources: self currentObjectStateBinding validHandle.
		
	renderable renderOn: commandList mode: renderMode submode: submode instanceCount: 1 baseInstance: 0 baseVertex: 0