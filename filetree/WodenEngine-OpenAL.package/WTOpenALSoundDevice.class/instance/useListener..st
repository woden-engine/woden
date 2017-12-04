as yet unclassified
useListener: soundListener
	currentListener := soundListener.
	currentListener ifNotNil: [ soundListener sendValues ]