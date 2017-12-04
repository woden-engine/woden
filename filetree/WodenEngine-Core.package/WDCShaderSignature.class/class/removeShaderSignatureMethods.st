removing
removeShaderSignatureMethods
	| protocol |
	protocol := (self organization protocolNamed: self shaderSignatureMethodCategory).
	protocol ifNil: [ ^ self ].
	protocol methods asArray do: [ :method |
		self removeSelector: method
	]