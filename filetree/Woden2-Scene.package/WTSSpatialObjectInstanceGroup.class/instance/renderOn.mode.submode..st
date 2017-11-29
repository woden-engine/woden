rendering
renderOn: commandList mode: renderMode submode: submode
	renderable ifNil: [ ^ self ].
	
	commandList
		useShaderResources: self currentObjectStateBinding validHandle.
		
	renderable renderOn: commandList mode: renderMode submode: submode instanceCount: children size baseInstance: 0 baseVertex: 0