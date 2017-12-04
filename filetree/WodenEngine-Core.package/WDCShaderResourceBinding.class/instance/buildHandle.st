resource building
buildHandle
	handle := shaderSignature handle createShaderResourceBinding: element.
	slots do: [ :slot | slot value ]