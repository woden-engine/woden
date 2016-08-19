transforming
computeTransformationInto: box
	<argument: #box type: #(WMBox3DD object)>
	(self isEmpty or: [ box isEmpty ]) ifTrue: [ ^ WMReversibleAffineTransformD identity ].
	^ WMReversibleAffineTransformD identity
		translateBy: self center negated;
		scaleBy: box halfExtent / self halfExtent;
		translateBy: box center;
		yourself