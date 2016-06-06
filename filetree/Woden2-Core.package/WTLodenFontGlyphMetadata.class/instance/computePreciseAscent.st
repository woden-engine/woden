metrics
computePreciseAscent
	<var: #extraY type: #float>
	| extraY |
	extraY := box max y - box min y - size y.  
	^ horizontalBearing y floor - extraY floor