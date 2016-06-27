rendering
simulateTime: delta
	| gunBoundingBox translatedPlayerBox |
	super simulateTime: delta.

	translatedPlayerBox := playerBox translatedBy: camera transform translation.
	translatedPlayerBox min y < 0 ifTrue: [
		cameraVelocity y: 0.0.
		camera transform translateByY: translatedPlayerBox min y negated.
		translatedPlayerBox := playerBox translatedBy: camera transform translation.
	].

	floorGun ifNotNil: [
		gunBoundingBox := floorGun renderable boundingBox translatedBy: floorGun transform translation.
		Transcript
			show: gunBoundingBox; cr;
			show: gunBoundingBox extent; cr;
			show: translatedPlayerBox; cr;
			show: translatedPlayerBox extent; cr;
			show: (translatedPlayerBox intersectsOrContainsBox: gunBoundingBox); cr.
		(translatedPlayerBox intersectsOrContainsBox: gunBoundingBox) ifTrue: [
			self pickGun.
			floorGun removeFromScene.
			floorGun := nil.
		]
	].
