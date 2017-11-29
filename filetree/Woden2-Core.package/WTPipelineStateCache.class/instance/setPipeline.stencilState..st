pipeline state object building
setPipeline: pipeline stencilState: stateDescription
	| enabled readMask writeMask |
	enabled := stateDescription at: 'enabled'.
	readMask := stateDescription at: 'read-mask'.
	writeMask := stateDescription at: 'write-mask'.
	pipeline setStencilState: enabled asBit writeMask: writeMask readMask: readMask