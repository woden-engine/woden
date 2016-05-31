resource building
createShaderSignature: shaderSignature resourceBinding: element
	^ (WTShaderResourceBinding for: self)
		shaderSignature: shaderSignature;
		element: element;
		checkSession;
		yourself