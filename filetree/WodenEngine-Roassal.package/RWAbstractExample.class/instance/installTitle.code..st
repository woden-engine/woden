installing
installTitle: aTitle code: sourceCode
	"SourceCode should be a complete example, executable within a workspace"
	
	| viewOrBuilder  icon64Mime stream window viewWindow | 
	viewOrBuilder := (Compiler evaluate: sourceCode).
	
	viewWindow := RWViewWindow new.
	viewWindow view: viewOrBuilder.
	window := viewWindow openInMorphic.
		
"	canvas morph ifNil: [ self error: 'You have forgotten to open the view!' ].
"	
	(self class methodDict includesKey: ('example', aTitle) asSymbol)
		ifTrue: [ self error: 'Title already used. Proceed to override' ].
	
	self class compile: 'example', aTitle, String cr, sourceCode classified: 'sources'.
	
	stream := WriteStream on: ByteArray new.
	TRPlatform current pngReadWriterClass
				putForm: (window imageForm scaledToSize: 100 @ 100)
				onStream: stream .
	icon64Mime := (TRPlatform current mimeEncode: stream contents readStream) contents.
	self class compile: 'example', aTitle, 'Icon', String cr, '	^ ''', icon64Mime, '''' classified: 'icons'.
	window delete.