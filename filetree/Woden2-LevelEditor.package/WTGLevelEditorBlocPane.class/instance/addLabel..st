as yet unclassified
addLabel: label
	bloc addChild: (BrLabel new
		text: label;
		constraintsDo:[:c| c alignCenter.])
	