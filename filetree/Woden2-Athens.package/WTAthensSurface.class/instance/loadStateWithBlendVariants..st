initialization
loadStateWithBlendVariants: prefix
	| result fullName |
	result := IdentityDictionary new.
	BlendVariantNames do: [ :variant |
		fullName := (prefix , variant first) asSymbol.
		result at: variant second put: (engine pipelineStateManager pipelineStateNamed: fullName)
	].
	^ result.
	