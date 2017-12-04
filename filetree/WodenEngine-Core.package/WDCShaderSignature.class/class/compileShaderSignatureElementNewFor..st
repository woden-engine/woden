compiling
compileShaderSignatureElementNewFor: spec
	spec elements do: [ :element | element compileShaderSignatureElementNewIn: self ]