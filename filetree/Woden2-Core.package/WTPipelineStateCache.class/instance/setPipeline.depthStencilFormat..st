pipeline state object building
setPipeline: pipeline depthStencilFormat: formatName
	| format |
	format := (AGPUConstants bindingOf: ('AGPU_TEXTURE_FORMAT_' , formatName) asSymbol) value.
	pipeline setDepthStencilFormat: format