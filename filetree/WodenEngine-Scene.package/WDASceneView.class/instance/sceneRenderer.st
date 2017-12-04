rendering process stages
sceneRenderer
	^ sceneRenderer ifNil: [sceneRenderer := WDSForwardSceneRenderer for: engine].
