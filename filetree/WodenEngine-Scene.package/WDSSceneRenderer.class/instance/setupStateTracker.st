rendering
setupStateTracker
	stateTracker
		reset;
		mode: self renderMode;
		shaderSignature: self shaderSignature;
		useShaderResources: self shaderSignature defaultSamplers;
		
		frontFaceWinding: AGPU_COUNTER_CLOCKWISE;
		cullMode: AGPU_CULL_MODE_BACK;
		depthEnabled: true;
		depthWriteMask: true;
		depthFunction: AGPU_GREATER_EQUAL;

		blendingAllMode: WDCBlendingMode replace.