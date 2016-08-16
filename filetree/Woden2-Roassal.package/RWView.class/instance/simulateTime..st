as yet unclassified
simulateTime: delta
	"Accumulate the total time"
	currentTime := currentTime + currentTime.
	elements do: [ :element | element simulateTime: delta ]