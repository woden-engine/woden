as yet unclassified
renderLodenFont: font characters: aString from: start to: end
	| originalFace pipelineState scaleFactor currentPosition |
	originalFace := font originalFace.
	currentColor := currentCanvas paint isColor ifTrue: [ currentCanvas paint ] ifFalse: [ Color black ].
	currentColor := currentColor asWMVector4F.
	pipelineState := originalFace sdfFont ifTrue: [ textSdfColorPipeline ] ifFalse: [ textColorPipeline ].
	scaleFactor := font scaleFactor.
	self
		beginShape: AGPU_TRIANGLES pipeline: pipelineState texture: nil font: originalFace texture.
	
	currentPosition := WMVector2F new.
	start to: end do: [ :i |
		currentPosition := self renderLodenFont: originalFace scaleFactor: scaleFactor character: (aString at: i) position: currentPosition
	]