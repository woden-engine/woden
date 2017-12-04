as yet unclassified
setFPSModelIn: sceneNode
	fpsModel ifNil: [
		fpsModel := sceneNode engine resourceCache loadMesh: self fpsModelName
	].
	sceneNode renderable: fpsModel