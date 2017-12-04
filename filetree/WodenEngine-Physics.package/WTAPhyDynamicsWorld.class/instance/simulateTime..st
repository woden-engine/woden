rendering
simulateTime: delta
	onSimulation := true.
	[
		handle stepSimulation: delta max_sub_steps: 2 fixed_time_step: 1.0/120.0.
		rigidBodies do: [ :body | self updateSceneNodeFromRigidBody: body ]
	] ensure: [ onSimulation := false ]