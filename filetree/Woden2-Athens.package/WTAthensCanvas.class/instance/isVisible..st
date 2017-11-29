bloc clipping
isVisible: aRectangle
	"Return true if the given rectangle is (partially) visible"
	^ true"(currentClipRect ifNil: [ ^ true ]) intersects: aRectangle"