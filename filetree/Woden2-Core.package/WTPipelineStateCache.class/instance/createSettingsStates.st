initialization
createSettingsStates
	| scope settingStates |
	scope := 'settings.rendering.'.
	settingStates := { 
		WTPipelineState new
			name: (scope , 'sample-description') asSymbol;
			scope: scope;
			description: (Dictionary newFromPairs: {
				'sample-description' . Dictionary newFromPairs: {
					'count' . 1.
					'quality' . 0.
				}
			});
			isAbstract: true.
		WTPipelineState new
			name: (scope , 'depth-stencil-format') asSymbol;
			scope: scope;
			description: (Dictionary newFromPairs: {
				'depth-stencil-format' . engine preferredDepthStencilFormat
			});
			isAbstract: true.
		WTPipelineState new
			name: (scope , 'depth-format') asSymbol;
			scope: scope;
			description: (Dictionary newFromPairs: {
				'depth-stencil-format' . engine preferredDepthFormat
			});
			isAbstract: true.
	}.
	
	settingStates do: [ :settingState |
		pipelineStateObjects at: settingState name put: settingState
	]