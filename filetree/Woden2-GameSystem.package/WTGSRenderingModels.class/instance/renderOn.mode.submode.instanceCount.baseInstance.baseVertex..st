rendering
renderOn: listBuilder mode: renderMode submode: submode instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex 
	| model |
	
	model := self modelForSubMode: submode.
	model renderOn: listBuilder mode: renderMode submode: #full instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex 