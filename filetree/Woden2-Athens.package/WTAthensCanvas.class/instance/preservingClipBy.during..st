bloc clipping
preservingClipBy: aRectangle during: aBlock
	| oldClip  |
	oldClip := currentClipRect.
	" Works only if aRectangle is given according to a global coordinate reference"
	"currentClipRect := oldClip ifNil: [ aRectangle ] ifNotNil: [ oldClip intersect: aRectangle ifNone:[^ self] ]. "
	aBlock ensure: [ 
		currentClipRect := oldClip
	]