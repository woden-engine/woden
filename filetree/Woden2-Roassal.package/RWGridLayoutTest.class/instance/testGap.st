as yet unclassified
testGap
	| layout |
	layout := RWXZGridLayout new.
	self assert: layout gap = 1.
	layout gap: 2.
	self assert: layout gap = 2.