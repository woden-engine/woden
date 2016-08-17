as yet unclassified
thumbnail
	| bestLevel levelWidth levelHeight scale |
	bestLevel := 1.
	levelWidth := width.
	levelHeight := height.
	[ levelWidth > ThumbnailSize or: [ levelHeight > ThumbnailSize ] ] whileTrue: [
		levelWidth := levelWidth // 2.
		levelHeight := levelHeight // 2.
		bestLevel := bestLevel + 1
	].

	bestLevel <= miplevels ifTrue: [
		^ self convertToFormLayer: 1 level: bestLevel
	].

	scale := ThumbnailSize / (width max: height).
	^ self firstLayerLevelAsForm scaledToSize: ((width*scale min: ThumbnailSize) asInteger @ (height *scale min: ThumbnailSize) asInteger)