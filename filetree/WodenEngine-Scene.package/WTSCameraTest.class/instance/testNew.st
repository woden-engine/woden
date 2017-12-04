as yet unclassified
testNew
	| camera |
	camera := WTSCamera new.
	self assert: camera cameraState isNotNil.