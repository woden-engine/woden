viewport composition
composeEyesIn: stateTracker
	| resolveTarget renderPass |
	resolveTarget := view window validResolveRenderTarget.

	renderPass := resolveTarget validMainRenderPass.

	stateTracker reset;
		shaderSignature: self shaderSignature;
		frontFaceWinding: AGPU_COUNTER_CLOCKWISE;
		cullMode: AGPU_CULL_MODE_NONE;
		depthEnabled: false;
		blendingAllMode: WDCBlendingMode alphaOver; 
		
		beginRenderPass: renderPass renderTarget: resolveTarget bounds: resolveTarget bounds;
	
		vertexShader: self vertexShader;
		fragmentShader: self fragmentShader;
		useShaderResources: compositionStateBinding;
		useShaderResources: sourceRenderTargetsBinding;
		useShaderResources: self shaderSignature defaultSamplers;
		primitiveType: AGPU_TRIANGLE_STRIP;
		drawArrays: 4 instance_count: 1 first_vertex: 0 base_instance: 0;
		
		endRenderPass