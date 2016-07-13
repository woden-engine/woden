as yet unclassified
rebuildPlane
	| v1 v2 v3 u v n d d2 d3|
	v1 := self positionAt: 1.
	v2 := self positionAt: 2.
	v3 := self positionAt: 3.
	u := v2 - v1.
	v := v3 - v1.
	n := (u cross: v) normalized.
	d := v1 dot: n.
	d2 := v2 dot: n.
	d3 := v3 dot: n.
	plane := WMPlaneD normal: n distance: d.