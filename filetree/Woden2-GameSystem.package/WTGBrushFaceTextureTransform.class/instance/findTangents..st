private
findTangents: aNormal
	| dirIndex ui vi u v |
	dirIndex := self findDirectionIndex: aNormal .
	
	"Initial candidate for the direction"
	ui := UDirections at: dirIndex.
	vi := VDirections at: dirIndex.
	
	"Gram-Schmidth orthogonalization for better tangent vectors."
	u := (ui - (aNormal * (aNormal dot: ui))) normalized.
	v := (vi - (aNormal * (aNormal dot: vi)) - (u * (u dot: vi))) normalized.
	^ { u . v }