code generation
compileShaderSignatureElementNewIn: aClass
	| code |
	code := ByteString streamContents: [ :out |
		out << 'new' << name; cr.
		out tab << '^ engine createShaderSignature: self resourceBinding: ' << index << ' elements: ' << totalBindingPointCount
	].
	aClass compileShaderSignatureMethod: code