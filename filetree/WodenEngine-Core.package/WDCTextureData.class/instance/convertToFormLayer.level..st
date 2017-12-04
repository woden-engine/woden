converting
convertToFormLayer: layerIndex level: levelIndex
	^ self convertLevelToForm: ((layers at: layerIndex) levels at: levelIndex)