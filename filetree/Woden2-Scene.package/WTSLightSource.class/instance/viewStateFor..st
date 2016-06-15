accessing
viewStateFor: cameraTansform
	| result |
	result := state copy.
	type == #directional ifTrue: [ 
	] ifFalse: [
		result position: (cameraTansform inverseTransformPosition3: transform translation).
	].

	^ result