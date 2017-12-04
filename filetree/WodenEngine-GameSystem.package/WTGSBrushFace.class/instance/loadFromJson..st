serialization
loadFromJson: jsonData
	material := jsonData at: 'material'.
	plane := WMPlaneD loadFromJson: (jsonData at: 'plane').
	textureTransform := WTGBrushFaceTextureTransform loadFromJson: (jsonData at: 'texture-transform').
	