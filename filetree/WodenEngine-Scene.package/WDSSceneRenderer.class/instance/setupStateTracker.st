rendering
setupStateTracker
	stateTracker
		mode: self renderModeName;
		shaderSignature: self shaderSignature;
		useShaderResources: samplerBindings;
		
		frontFaceWinding: AGPU_COUNTER_CLOCKWISE;
		cullMode: AGPU_CULL_MODE_BACK;
		depthEnabled: true;
		depthWriteMask: true;
		depthFunction: AGPU_GREATER_EQUAL;

		blendingAllEnabled: true sourceFactor: AGPU_BLENDING_SRC_ALPHA destFactor: AGPU_BLENDING_INVERTED_SRC_ALPHA operation: AGPU_BLENDING_OPERATION_ADD 
