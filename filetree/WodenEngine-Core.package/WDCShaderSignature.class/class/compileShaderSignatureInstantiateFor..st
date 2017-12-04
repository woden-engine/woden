compiling
compileShaderSignatureInstantiateFor: spec
	| code |
	code := ByteString streamContents: [ :out |
		out << 'createHandleForDevice: device'; cr.
		out tab << '^ device createShaderSignatureBuilder'; cr; cr.
		spec elements do: [ :element | element writeCreateHandleCodeOn: out ].

		out tab tab << 'build'; cr.
	].

	self compileShaderSignatureMethod: code