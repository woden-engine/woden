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
		blendingAllEnabled: false sourceFactor: AGPU_BLENDING_SRC_ALPHA destFactor: AGPU_BLENDING_INVERTED_SRC_ALPHA operation: AGPU_BLENDING_OPERATION_ADD; 
		
		beginRenderPass: renderPass renderTarget: resolveTarget bounds: resolveTarget bounds;
	
		vertexShader: self vertexShader;
		fragmentShader: self fragmentShader;
		useShaderResources: compositionStateBinding;
		useShaderResources: sourceRenderTargetsBinding;
		useShaderResources: self samplerBindings;
		primitiveType: AGPU_TRIANGLE_STRIP;
		drawArrays: 4 instance_count: 1 first_vertex: 0 base_instance: 0;
		
		endRenderPass