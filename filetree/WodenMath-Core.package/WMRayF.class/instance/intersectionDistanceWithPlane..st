intersection
intersectionDistanceWithPlane: plane
	<argument: #plane type: #(WMPlaneF object)>
	"This method computes a ray plane intersection. It should be a point."
	| det normal |
	normal := plane normal.
	det := direction dot: normal.
	(det closeTo: 0.0) ifTrue: [ ^ nil ].
	
	^ (plane distance - (normal dot: origin)) / det.
	