pipeline state object building
setPipeline: builder renderTargetFormats: renderTargetFormats
	| format |
	builder setRenderTargetCount: renderTargetFormats size.
	renderTargetFormats doWithIndex: [:formatName :index |
		format := (AGPUConstants bindingOf: ('AGPU_TEXTURE_FORMAT_' , formatName) asSymbol) value.
		builder setRenderTargetFormat: index - 1 format: format.
	].
