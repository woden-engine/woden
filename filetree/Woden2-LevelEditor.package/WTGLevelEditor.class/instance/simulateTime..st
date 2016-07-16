rendering
simulateTime: delta
	super simulateTime: delta.
	levelViews do: [ :view | view simulateCameraMovement: delta ].
