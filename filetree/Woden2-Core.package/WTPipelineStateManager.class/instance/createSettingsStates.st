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
	}.
	
	settingStates do: [ :settingState |
		pipelineStateObjects at: settingState name put: settingState
	]