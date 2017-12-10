resource building
buildHandle
	handle := shaderSignature handle createShaderResourceBinding: binding.
	slotActions do: [ :slot | slot value ]