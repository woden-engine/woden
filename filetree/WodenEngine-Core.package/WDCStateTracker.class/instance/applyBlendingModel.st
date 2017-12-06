as yet unclassified
applyBlendingModel
	materialBlendingMode ifNotNil: [
		^ self blendingAllMode: materialBlendingMode.
	].

	objectBlendingMode ifNotNil: [
		^ self blendingAllMode: objectBlendingMode.
	]
