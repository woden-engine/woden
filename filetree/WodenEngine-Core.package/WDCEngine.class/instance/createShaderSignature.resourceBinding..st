resource building
createShaderSignature: shaderSignature resourceBinding: element
	^ (WDCShaderResourceBinding for: self)
		shaderSignature: shaderSignature;
		element: element;
		checkSession;
		yourself