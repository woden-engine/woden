selection
findElementsAtWindowCoord: coord
	| ray |
	ray := self rayAtWindowCoord: coord.
	Transcript show: ray; cr.