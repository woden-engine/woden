rendering
updateWithDeltaTime: deltaTime
	| frameCount updateTimeStep |
	accumulatedUpdateTime := accumulatedUpdateTime + deltaTime.
	updateTimeStep := self updateTimeStep.
	frameCount := 0.
	[ accumulatedUpdateTime > updateTimeStep] whileTrue: [
		self simulateTime: updateTimeStep.
		accumulatedUpdateTime := accumulatedUpdateTime - updateTimeStep.
		frameCount := frameCount + 1
	].
	
	^ accumulatedUpdateTime
	