public normalize size
normalizeSize: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation
	"aBlock is evaluated on each node model. 
	 Colors is an array of colors used to do the fading"

	| values |
	self checkNotEmpty.
	
	values := (self getNormalizedValues: metricBlock 
							min: min max: max 
							minValue: minValue maxValue: maxValue 
							using: transformation).
	elements with: values do: [ :el :v | el trachelShape extent: v @ v ] 
	
	
"	(maxValue - minValue) ~= 0 ifTrue: [
		elements do: [ :el | 
			| tt t |
			t := transformation rtValue: (metricBlock rtValue: el model).
			tt := min + ((max - min) * ( (t - minValue) / (maxValue - minValue))) asInteger.
			el trachelShape extent: tt @ tt ] ] 
	
	"