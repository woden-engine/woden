as yet unclassified
signatureSpec: spec
	"
	self rebuildShaderSignatureMethods
	"
	spec
		name: #Composition;
		bank: #Parameters with: [ :bank |
			bank
				maxBindings: 1000;
				uniform: #Parameters
		];
		bank: #Source with: [ :bank |
			bank
				maxBindings: 1000;
				texture: #LeftTexture;
				texture: #RightTexture
		];
		bank: #Samplers with: [ :bank |
			bank
				maxBindings: 10;
				sampler: #Sampler
		];
		yourself