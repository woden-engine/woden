as yet unclassified
signatureSpec: spec
	"
	self rebuildShaderSignatureMethods
	"
	spec
		name: #ForwardRenderer;
		bank: #ObjectState with: [ :bank |
			bank
				maxBindings: 100000;
				uniform: #ObjectState;
				storage: #InstanceObjectState;
				storage: #ExtraObjectState
		];
		bank: #CameraState with: [ :bank |
			bank
				maxBindings: 1000;
				uniform: #ObjectState
		];
		bank: #LightingState with: [ :bank |
			bank
				maxBindings: 100;
				uniform: #GlobalLightingState
		];
		bank: #MaterialState with: [ :bank |
			bank
				maxBindings: 10000;
				uniform: #Attributes;
				storage: #BigAttributes;
				texture: #Textures count: 5
		];
		bank: #Samplers with: [ :bank |
			bank
				maxBindings: 10;
				sampler: #Samplers count: 5
		];
		yourself