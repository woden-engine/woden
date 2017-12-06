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

		blendingAllMode: WDCBlendingMode replace.
