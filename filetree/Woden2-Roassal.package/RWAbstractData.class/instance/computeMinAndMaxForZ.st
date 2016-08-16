as yet unclassified
computeMinAndMaxForZ
	| computed |
	computed := elements collect: z.
	self assert: [ computed allSatisfy: [ :obj | obj isKindOf: Number ] ] description: 'You have provided objects that are not number. Please adjust what you provide to #points: #x: and #y:'.
	minZ := computed min.
	maxZ := computed max.
	
	(minZ < 0 and: [ maxZ < 0 ]) ifTrue: [ maxZ := 0 ].
	(minZ > 0 and: [ maxZ > 0 ]) ifTrue: [ minZ := 0 ].
	