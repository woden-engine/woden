enumerating
textureTransformsDo: aBlock
	faces do: [ :face | face textureTransformsDo: aBlock ]