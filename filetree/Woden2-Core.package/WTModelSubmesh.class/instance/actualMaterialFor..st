as yet unclassified
actualMaterialFor: anEngine
	material isString ifTrue: [ ^ anEngine resourceCache loadMaterial: material ].
	^ material