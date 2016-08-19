intersection
intersectWithBox: box
	"This method computes a ray box intersection. It should be a point."
	^ self pointAtDistance: (self intersectionDistanceWithBox: box).