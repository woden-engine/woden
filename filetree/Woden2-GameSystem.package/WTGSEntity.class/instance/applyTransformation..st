as yet unclassified
applyTransformation: transformation
	| spatialDescription |
	spatialDescription := self spatialDescription.
	spatialDescription ifNotNil: [ spatialDescription applyTransformation: transformation ].