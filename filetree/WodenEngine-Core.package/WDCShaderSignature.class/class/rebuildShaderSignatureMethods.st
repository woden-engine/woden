as yet unclassified
rebuildShaderSignatureMethods
	| spec |
	spec := self parseSpec.
	self removeShaderSignatureMethods.
	self
		compileShaderSignatureInstantiateFor: spec;
		compileShaderSignatureElementNewFor: spec
	