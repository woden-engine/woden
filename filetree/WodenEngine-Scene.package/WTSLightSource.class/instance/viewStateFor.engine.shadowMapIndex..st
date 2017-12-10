as yet unclassified
viewStateFor: cameraTansform engine: engine shadowMapIndex: shadowMapIndex
	| result |
	result := state copy.
	type == #directional ifTrue: [
		result direction: (cameraTansform inverseTransformVector3: (renderTransform transformVector3: (WMVector3F z: 1.0))).
	] ifFalse: [
		result position: (cameraTansform inverseTransformPosition3: renderTransform translation).
	].

	type == #spot ifTrue: [ 
		result spotDirection: (cameraTansform inverseTransformVector3: (renderTransform transformVector3: (WMVector3F z: 1.0))).
		shadowMapIndex >= 0.0 ifTrue: [
			result
				shadowMapLayer: shadowMapIndex asFloat;
				shadowMapTransform: (self computeShadowMapMatrixForCameraTransform: cameraTansform engine: engine)
		]
	].

	^ result