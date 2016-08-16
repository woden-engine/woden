accessing
viewStateFor: cameraTansform
	| result |
	result := state copy.
	type == #directional ifTrue: [
		result direction: (cameraTansform inverseTransformVector3: (renderTransform transformVector3: (WMVector3F z: -1.0))).
	] ifFalse: [
		result position: (cameraTansform inverseTransformPosition3: renderTransform translation).
	].

	^ result