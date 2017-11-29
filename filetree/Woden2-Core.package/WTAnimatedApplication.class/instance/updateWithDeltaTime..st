rendering
updateWithDeltaTime: deltaTime
	| frameCount updateTimeStep iterationCount |
	accumulatedUpdateTime := accumulatedUpdateTime + deltaTime.
	updateTimeStep := self updateTimeStep.
	frameCount := 0.
	iterationCount := 0.
	[ accumulatedUpdateTime > updateTimeStep and: [ iterationCount < MaxUpdateIterationCount ]] whileTrue: [
		self simulateTime: updateTimeStep.
		accumulatedUpdateTime := accumulatedUpdateTime - updateTimeStep.
		frameCount := frameCount + 1.
		iterationCount := iterationCount + 1
	].
	
	^ accumulatedUpdateTime max: updateTimeStep
	