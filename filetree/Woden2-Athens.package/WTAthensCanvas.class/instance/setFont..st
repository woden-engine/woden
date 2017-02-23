initialization
setFont: aFont
	"Set the current font of receiver. Font object should answer a glyph renderer instance,
	compatible with glyph renderer protocol" 
	aFont ifNil: [ ^ nil ].
	^ fontRenderer := aFont glyphRendererOn: surface.