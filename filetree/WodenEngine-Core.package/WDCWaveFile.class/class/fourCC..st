as yet unclassified
fourCC: aString
	self assert: aString size = 4.
	^ aString asByteArray unsignedLongAt: 1 bigEndian: false