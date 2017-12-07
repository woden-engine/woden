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
		blendingAllMode: WDCBlendingMode add; 
		
		beginRenderPass: renderPass renderTarget: resolveTarget bounds: resolveTarget bounds;
	
		vertexShader: self vertexShader;
		fragmentShader: self fragmentShader;
		useVertexBinding: screenGridVertexBinding;
		useIndexBuffer: screenGridIndexBuffer;
		useShaderResources: compositionStateBinding;
		useShaderResources: sourceRenderTargetsBinding;
		useShaderResources: self samplerBindings;
		primitiveType: AGPU_TRIANGLES;
		drawElements: screenGridIndexCount instance_count: 6 first_index: 0 base_vertex: 0 base_instance: 0;
		endRenderPass