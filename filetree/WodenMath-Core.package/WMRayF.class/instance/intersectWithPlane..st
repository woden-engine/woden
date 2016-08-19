intersection
intersectWithPlane: plane
	"This method computes a ray box intersection. It should be a point."
	^ self pointAtDistance: (self intersectionDistanceWithPlane: plane).