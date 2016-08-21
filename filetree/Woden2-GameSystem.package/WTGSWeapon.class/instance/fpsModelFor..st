as yet unclassified
fpsModelFor: anEngine
	fpsModel ifNil: [
		fpsModel := anEngine resourceCache loadMesh: self fpsModelName
	].
	^ fpsModel