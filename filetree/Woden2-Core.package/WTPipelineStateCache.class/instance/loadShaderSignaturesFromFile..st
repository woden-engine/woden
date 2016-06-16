state loading
loadShaderSignaturesFromFile: aFileName
	| signaturesJson |
	signaturesJson := self readJsonFromFile: aFileName.
	signaturesJson keysAndValuesDo: [ :name :signatureDesc | self loadNamed: name asSymbol shaderSignature: signatureDesc ].