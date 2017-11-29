accessing
alphaColor: anAlphaValue
	"Set an alpha color (transparency) for nodes"
	"aFloat has to be between 0.0 and 1.0"
	elements do: [ :el | 
				el trachelShape color: (el trachelShape color alpha: anAlphaValue) ] 
		 