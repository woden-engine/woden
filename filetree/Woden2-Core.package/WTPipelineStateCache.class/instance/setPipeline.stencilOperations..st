pipeline state object building
setPipeline: pipeline stencilOperations: stateDescription
	| stencilFailOp depthFailOp stencilDepthPassOp function |
	stencilFailOp := StencilOperationNameMap at: (stateDescription at: 'stencil-fail').
	depthFailOp := StencilOperationNameMap at: (stateDescription at: 'depth-fail').
	stencilDepthPassOp := StencilOperationNameMap at: (stateDescription at: 'stencil-depth-pass').
	function := CompareFunctionNameMap at: (stateDescription at: 'function').
	pipeline setStencilFrontFace: stencilFailOp depthFailOperation: depthFailOp stencilDepthPassOperation: stencilDepthPassOp stencilFunction: function.
	pipeline setStencilBackFace: stencilFailOp depthFailOperation: depthFailOp stencilDepthPassOperation: stencilDepthPassOp stencilFunction: function.