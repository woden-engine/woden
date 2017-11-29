rendering
simulateTime: delta
	"Accumulate the total time"
	currentTime := currentTime + currentTime.
	self simulatePhysics: delta.
	elements do: [ :element | element simulateTime: delta ].
	internalElements do: [ :element | element simulateTime: delta ].
