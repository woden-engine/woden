as yet unclassified
convertToFloat: string thenSetWith: selector
	| selection number |
	selection := editor selection.
	selection elements ifEmpty: [ ^ self ].
	Transcript show: string; cr.
	number := Number readFrom: string asString ifFail: [ ^ self ].
	Transcript show: number; cr.
	selection perform: selector with: number asFloat.