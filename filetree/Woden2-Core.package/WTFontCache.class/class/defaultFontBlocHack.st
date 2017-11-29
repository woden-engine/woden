class initialization
defaultFontBlocHack
	DefaultFontBlocHack ifNil: [ 
		DefaultFontBlocHack := self new loadLodenFontFaceMetadataNamed: #default fromFile: 'core-assets/fonts/dejavu/DejaVuSans.lodenfnt' asFileReference
	].

	^ DefaultFontBlocHack