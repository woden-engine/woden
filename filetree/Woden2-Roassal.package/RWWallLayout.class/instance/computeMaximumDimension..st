position calculation
computeMaximumDimension: nodes
	^ (nodes
		inject: WDVector3 zero
		into: [ :maxiumDimension :each |
			| boundingBoxDimension |
			boundingBoxDimension := each extent.
			maxiumDimension
				x: (maxiumDimension x max: boundingBoxDimension x);
				y: (maxiumDimension y max: boundingBoxDimension y);
				z: (maxiumDimension z max: boundingBoxDimension z);
				yourself ]) + (WDVector3 x: gap y: gap z: gap)