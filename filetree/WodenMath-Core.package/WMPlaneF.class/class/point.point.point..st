construction
point: firstPoint point: secondPoint point: thirdPoint
	| u v n d |
	u := secondPoint - firstPoint.
	v := thirdPoint - firstPoint.
	n := (u cross: v) normalized.
	d := n dot: firstPoint.
	^ self normal: n distance: d