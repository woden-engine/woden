parsing
parseSpec
	| spec |
	spec := WDCShaderSignatureSpec new.
	self signatureSpec: spec.
	^ spec