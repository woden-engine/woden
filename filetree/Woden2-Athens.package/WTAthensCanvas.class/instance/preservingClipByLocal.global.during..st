bloc clipping
preservingClipByLocal: aLocalRectangle global: aGlobalRectangle during: aBlock
	| oldClip |
	oldClip := currentClipRect.
	"currentClipRect := oldClip
		ifNil: [ aGlobalRectangle ]
		ifNotNil: [ oldClip intersect: aGlobalRectangle ifNone: [ ^ self ] ]."
	aBlock ensure: [ 
		currentClipRect := oldClip
	]