pipeline state object building
setPipeline: pipeline depthStencilFormat: formatNameOrValue
	| format |
	formatNameOrValue isInteger ifTrue: [ 
		pipeline setDepthStencilFormat: formatNameOrValue
	] ifFalse: [ 
		format := (AGPUConstants bindingOf: ('AGPU_TEXTURE_FORMAT_' , formatNameOrValue) asSymbol) value.
		pipeline setDepthStencilFormat: format
	]
