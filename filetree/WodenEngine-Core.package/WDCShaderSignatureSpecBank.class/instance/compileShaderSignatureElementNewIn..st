code generation
compileShaderSignatureElementNewIn: aClass
	| code |
	code := ByteString streamContents: [ :out |
		out << 'new' << name; cr.
		out tab << '^ engine createShaderSignature: self resourceBinding: ' << index
	].
	aClass compileShaderSignatureMethod: code