as yet unclassified
createColorRampDescription: aColorRamp
	| description |
	description := WTColorRampDescription new
		firstIndex: colorRampEntries size;
		count: aColorRamp size;
		yourself.
	colorRampEntries addAll: aColorRamp.
	colorRampDictionary at: aColorRamp put: description.
	^ description
		