resource building
createShaderSignature: shaderSignature resourceBinding: binding elements: elements
	^ (WDCShaderResourceBinding for: self)
			elements: elements;
			shaderSignature: shaderSignature;
			binding: binding;
			checkSession;
			yourself