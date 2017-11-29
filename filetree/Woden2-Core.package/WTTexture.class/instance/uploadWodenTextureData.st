resource building
uploadWodenTextureData
	data layers doWithIndex: [ :layer :layerIndex |
		layer levels doWithIndex: [ :level :levelIndex |
			handle uploadTextureData: levelIndex - 1 arrayIndex: layerIndex - 1 pitch: level pitch slicePitch: level slicePitch data: level data.
		]
	]