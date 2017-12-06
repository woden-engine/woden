icon
smallRoassal
	"Private - Generated method"
	^  Form fromBinaryStream: (self mimeDecodeToBytes: self smallRoassalContents readStream)