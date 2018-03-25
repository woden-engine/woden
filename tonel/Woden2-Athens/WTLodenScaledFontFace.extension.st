Extension { #name : #WTLodenScaledFontFace }

{ #category : #'*Woden2-Athens' }
WTLodenScaledFontFace >> glyphRendererOn: surface [
	^ WTAthensLodentFontGlyphRenderer new font: self; surface: surface; yourself
]
