Class {
	#name : #RWMetricNormalizer,
	#superclass : #RWObject,
	#instVars : [
		'elements',
		'view',
		'translator',
		'edges'
	],
	#category : #'WodenEngine-Roassal-Normalizer'
}

{ #category : #accessing }
RWMetricNormalizer >> alphaColor [
	"Make all the elements translucent"
	^ self alphaColor: 0.4
]

{ #category : #accessing }
RWMetricNormalizer >> alphaColor: anAlphaValue [
	"Set an alpha color (transparency) for nodes"
	"aFloat has to be between 0.0 and 1.0"
	elements do: [ :el | 
				el trachelShape color: (el trachelShape color alpha: anAlphaValue) ] 
		 
]

{ #category : #utility }
RWMetricNormalizer >> checkNotEmpty [
	"Raise an error if no elements have been added"
	elements ifEmpty: [ self error: 'Please specify what are the elements I should operate on using #elements:' ]
]

{ #category : #'public translation' }
RWMetricNormalizer >> directTranslation [
	translator := RTDirectLayoutTranslator new
]

{ #category : #'public normalize color' }
RWMetricNormalizer >> distinctColor [
	^ self distinctColorUsing: #yourself
]

{ #category : #'public normalize color' }
RWMetricNormalizer >> distinctColorUsing: aBlockOrSymbol [
	"Give a color to each element according to the result of execution the block and symbol on each element.

	For example, the following example paints all the class according to the package the class is in:
	| b |
	b := RTMondrian new.
	b shape circle.
	b nodes: Collection withAllSubclasses.
	b edges connectFrom: #superclass.
	b layout tree.
	b normalizer
		normalizeSize: #numberOfMethods;
		distinctColorUsing: #package.
	b	
	"
	| normalizer allObjects |
	allObjects := elements collect: [ :e | aBlockOrSymbol rtValue: e model ].
	allObjects removeDuplicates.
	
	normalizer := RTMultiLinearColorForIdentity new 
						objects: allObjects; 
						command: aBlockOrSymbol.

	elements do: [ :el | el trachelShape color: (normalizer rtValue: el model) ]
]

{ #category : #'public normalize line width' }
RWMetricNormalizer >> edges [
	edges ifNotNil: [ ^ edges ].
	
	edges := Set new.
	elements do: [ :el | edges addAll: el connectedEdges ]. 
	edges := edges asArray.
	^ edges
]

{ #category : #accessing }
RWMetricNormalizer >> elements: someElements [
	elements := someElements
]

{ #category : #'public translation' }
RWMetricNormalizer >> fastSmoothTranslation [
	translator := RTSmoothLayoutTranslator new nbCycles: 0.5; yourself
]

{ #category : #utility }
RWMetricNormalizer >> getElementNormalizedValues: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation [
	"aBlock is evaluated on each node model"

	self checkNotEmpty.
	(maxValue = minValue) ifTrue: [ 
		^ elements collect: [ :el | min ] ].
	
 	^ elements collect: [ :el | 
			| tt t |
			t := transformation rwValue: (metricBlock rwValue: el).
			tt := min + ((max - min) * ( (t - minValue) / (maxValue - minValue))) asInteger ]
]

{ #category : #utility }
RWMetricNormalizer >> getNormalizedForLineWidthValues: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation [
	"aBlock is evaluated on each node model"

	self checkNotEmpty.
	(maxValue = minValue) ifTrue: [ 
		^ self edges collect: [ :edge | min ] ].
	
 	^ self edges collect: [ :edge | 
			| tt t |
			t := transformation rwValue: (metricBlock value: edge from model value: edge to model).
			tt := min + ((max - min) * ( (t - minValue) / (maxValue - minValue))) asInteger ]
]

{ #category : #utility }
RWMetricNormalizer >> getNormalizedValues: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation [
	"aBlock is evaluated on each node model"

	self checkNotEmpty.
	(maxValue = minValue) ifTrue: [ 
		^ elements collect: [ :el | min ] ].
	
 	^ elements collect: [ :el | 
			| tt t |
			t := transformation rwValue: (metricBlock rwValue: el model).
			tt := min + ((max - min) * ( (t - minValue) / (maxValue - minValue))) asInteger ]
]

{ #category : #utility }
RWMetricNormalizer >> getValue: t min: min max: max minValue: minValue maxValue: maxValue [
	maxValue = minValue ifTrue: [ ^ min ].
	^ min + ((max - min) * ( (t - minValue) / (maxValue - minValue)))
]

{ #category : #initialization }
RWMetricNormalizer >> initialize [
	super initialize.
	elements := OrderedCollection new.
	self directTranslation
]

{ #category : #accessing }
RWMetricNormalizer >> maxSize: anInteger [
	"aBlock is evaluated on each node model. 
	Set the maximum size of each element"
	elements do: [ :el | 
		el trachelShape extent: (el trachelShape extent min: anInteger @ anInteger) ]
]

{ #category : #'public normalize color' }
RWMetricNormalizer >> normalizeColor: metricBlock [
	"aBlock is evaluated on each node model. 
	 Colors is an array of colors used to do the fading"
	^ self normalizeColor: metricBlock using: (Array with: Color gray with: Color red)
]

{ #category : #'public normalize color' }
RWMetricNormalizer >> normalizeColor: metricBlock using: colors [
	"aBlock is evaluated on each node model. 
	 Colors is an array of colors used to do the fading"
	^ self normalizeColor: metricBlock using: colors using: #yourself
]

{ #category : #'public normalize color' }
RWMetricNormalizer >> normalizeColor: metricBlock using: colors using: transformation [
	"aBlock is evaluated on each node model. 
	 Colors is an array of colors used to do the fading"
	
	| min max normalizer |
	"We get the min and the max of the metric for all the elements"
	min := 1000000.
	max := 0.
	elements do: [ :el | 
		| t |  
		t := transformation rtValue: (metricBlock rtValue: el model).
		min := min min: t.
		max := max max: t ].
	max = 0 ifTrue: [ ^ self ].
	
	normalizer := RTMultiLinearColor new colors: colors.
	elements do: [ :el |  
		el trachelShape color: (normalizer level: (((transformation rtValue: (metricBlock rtValue: el model)) - min) / max)) ]
]

{ #category : #'public normalize color' }
RWMetricNormalizer >> normalizeColorAsGray: metricBlock [
	"aBlock is evaluated on each node model."
	^ self normalizeColor: metricBlock using: (Array with: Color white with: Color black)
]

{ #category : #'public normalize color' }
RWMetricNormalizer >> normalizeColorUsing: colors [
	^ self normalizeColor: #yourself using: colors
]

{ #category : #'public normalize size' }
RWMetricNormalizer >> normalizeElementHeight: metricBlock [
	"metricBlock is evaluated on each node model"
	^ self normalizeElementHeight: metricBlock min: 5 max: 30
]

{ #category : #'public normalize size' }
RWMetricNormalizer >> normalizeElementHeight: metricBlock min: minValue max: maxValue [
	"metricBlock is evaluated on each node model. 
	 minValue and maxValue are integer representing the minimum and maximum size in pixels for each node"
	self normalizeElementHeight: metricBlock min: minValue max: maxValue using: #yourself
]

{ #category : #'public normalize size' }
RWMetricNormalizer >> normalizeElementHeight: metricBlock min: min max: max minValue: aMinValue maxValue: aMaxValue [
	"metricBlock is evaluated on each node model. 
	 minValue and maxValue are integer representing the minimum and maximum size in pixels for each node"
	self normalizeElementHeight: metricBlock min: min max: max minValue: aMinValue maxValue: aMaxValue using: #yourself
]

{ #category : #'public normalize size' }
RWMetricNormalizer >> normalizeElementHeight: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation [
	"metricBlock is evaluated on each node model. 
	 minValue and maxValue are integer representing the minimum and maximum size in pixels for each node"

	| values |
	self checkNotEmpty.
	values := (self getElementNormalizedValues: metricBlock 
							min: min max: max 
							minValue: minValue maxValue: maxValue 
							using: transformation).
	elements with: values do: [ :el :v | el trachelShape height: v ] 
	
	
]

{ #category : #'public normalize size' }
RWMetricNormalizer >> normalizeElementHeight: metricBlock min: min max: max using: transformation [
	"aBlock is evaluated on each node model. 
	 Colors is an array of colors used to do the fading"
	
	| minValue maxValue |
	
	self checkNotEmpty.

	"We get the min and the max of the metric for all the elements"
	minValue := transformation rwValue: (metricBlock rwValue: elements anyOne model).
	maxValue := minValue.
	elements do: [ :el | 
		| t |  
		t := transformation rwValue: (metricBlock rwValue: el).
		minValue := minValue min: t.
		maxValue := maxValue max: t ].
	
	self normalizeHeight: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation
]

{ #category : #'public normalize x' }
RWMetricNormalizer >> normalizeElementX: metricBlock min: min max: max minValue: minValue maxValue: maxValue [ 
	"
	metricBlock is evaluated on each element. 	

	min represent the X value of the minimum value.
	max represent the X value of the maximum value.
	
	minValue is the minimum value of the dataset.
	maxValue is the maximum value of the dataset.
	
	[ minValue ; maxValue ] is mapped to [ min ; max ]

	transformation is used to transform the metric value"
		
	self normalizeElementX: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: #yourself
]

{ #category : #'public normalize x' }
RWMetricNormalizer >> normalizeElementX: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation [
	"
	metricBlock is evaluated on each element. 	

	min represent the X value of the minimum value.
	max represent the X value of the maximum value.
	
	minValue is the minimum value of the dataset.
	maxValue is the maximum value of the dataset.
	
	[ minValue ; maxValue ] is mapped to [ min ; max ]

	transformation is used to transform the metric value"
		
	(maxValue - minValue) ~= 0 ifTrue: [
		elements do: [ :el | 
			| tt t |
			t := transformation rwValue: (metricBlock rwValue: el).
			tt := min + ((max - min) * ( (t - minValue) / (maxValue - minValue))) asInteger.
			translator translate: el to: el position + (WMVector3F x: tt asFloat y: 0.0 z: 0.0) ] ] 
]

{ #category : #'public normalize x' }
RWMetricNormalizer >> normalizeElementY: metricBlock min: min max: max minValue: minValue maxValue: maxValue [ 
	"
	metricBlock is evaluated on each element. 	

	min represent the Y value of the minimum value.
	max represent the Y value of the maximum value.
	
	minValue is the minimum value of the dataset.
	maxValue is the maximum value of the dataset.
	
	[ minValue ; maxValue ] is mapped to [ min ; max ]

	transformation is used to transform the metric value"
		
	self normalizeElementY: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: #yourself
]

{ #category : #'public normalize x' }
RWMetricNormalizer >> normalizeElementY: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation [
	"
	metricBlock is evaluated on each element. 	

	min represent the X value of the minimum value.
	max represent the X value of the maximum value.
	
	minValue is the minimum value of the dataset.
	maxValue is the maximum value of the dataset.
	
	[ minValue ; maxValue ] is mapped to [ min ; max ]

	transformation is used to transform the metric value"
		
	(maxValue - minValue) ~= 0 ifTrue: [
		elements do: [ :el | 
			| tt t |
			t := transformation rwValue: (metricBlock rwValue: el).
			tt := min + ((max - min) * ( (t - minValue) / (maxValue - minValue))) asInteger.
			translator translate: el to: el position + (WMVector3F x: 0.0 y: tt asFloat z: 0.0) ] ] 
]

{ #category : #'as yet unclassified' }
RWMetricNormalizer >> normalizeElementZ: metricBlock min: min max: max minValue: minValue maxValue: maxValue [ 
	"
	metricBlock is evaluated on each element. 	

	min represent the Y value of the minimum value.
	max represent the Y value of the maximum value.
	
	minValue is the minimum value of the dataset.
	maxValue is the maximum value of the dataset.
	
	[ minValue ; maxValue ] is mapped to [ min ; max ]

	transformation is used to transform the metric value"
		
	self normalizeElementZ: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: #yourself
]

{ #category : #'as yet unclassified' }
RWMetricNormalizer >> normalizeElementZ: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation [
	"
	metricBlock is evaluated on each element. 	

	min represent the X value of the minimum value.
	max represent the X value of the maximum value.
	
	minValue is the minimum value of the dataset.
	maxValue is the maximum value of the dataset.
	
	[ minValue ; maxValue ] is mapped to [ min ; max ]

	transformation is used to transform the metric value"
		
	(maxValue - minValue) ~= 0 ifTrue: [
		elements do: [ :el | 
			| tt t |
			t := transformation rwValue: (metricBlock rwValue: el).
			tt := min + ((max - min) * ( (t - minValue) / (maxValue - minValue))) asInteger.
			translator translate: el to: el position + (WMVector3F x: 0.0 y: 0.0 z: tt asFloat) ] ] 
]

{ #category : #'public normalize size' }
RWMetricNormalizer >> normalizeHeight: metricBlock [
	"metricBlock is evaluated on each node model"
	^ self normalizeHeight: metricBlock min: 5 max: 30
]

{ #category : #'public normalize size' }
RWMetricNormalizer >> normalizeHeight: metricBlock max: maxValue [
	"metricBlock is evaluated on each node model. 
	 maxValue is an integer representing the maximum size in pixels for each node"
	self normalizeHeight: metricBlock min: 5 max: maxValue
]

{ #category : #'public normalize size' }
RWMetricNormalizer >> normalizeHeight: metricBlock min: minValue max: maxValue [
	"metricBlock is evaluated on each node model. 
	 minValue and maxValue are integer representing the minimum and maximum size in pixels for each node"
	self normalizeHeight: metricBlock min: minValue max: maxValue using: #yourself
]

{ #category : #'public normalize size' }
RWMetricNormalizer >> normalizeHeight: metricBlock min: min max: max minValue: aMinValue maxValue: aMaxValue [
	"metricBlock is evaluated on each node model. 
	 minValue and maxValue are integer representing the minimum and maximum size in pixels for each node"
	self normalizeHeight: metricBlock min: min max: max minValue: aMinValue maxValue: aMaxValue using: #yourself
]

{ #category : #'public normalize size' }
RWMetricNormalizer >> normalizeHeight: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation [
	"metricBlock is evaluated on each node model. 
	 minValue and maxValue are integer representing the minimum and maximum size in pixels for each node"

	| values |

	self checkNotEmpty.
	
	values := (self getNormalizedValues: metricBlock 
							min: min max: max 
							minValue: minValue maxValue: maxValue 
							using: transformation).
	elements with: values do: [ :el :v | el trachelShape height: v ] 
	
	
]

{ #category : #'public normalize size' }
RWMetricNormalizer >> normalizeHeight: metricBlock min: min max: max using: transformation [
	"aBlock is evaluated on each node model. 
	 Colors is an array of colors used to do the fading"
	
	| minValue maxValue |
	
	self checkNotEmpty.

	"We get the min and the max of the metric for all the elements"
	minValue := transformation rwValue: (metricBlock rwValue: elements anyOne model).
	maxValue := minValue.
	elements do: [ :el | 
		| t |  
		t := transformation rwValue: (metricBlock rwValue: el model).
		minValue := minValue min: t.
		maxValue := maxValue max: t ].
	
	self normalizeHeight: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation
]

{ #category : #'public normalize line width' }
RWMetricNormalizer >> normalizeLineWidth: metricBlock [
	"metricBlock is a two arg block that accept the from model and the to model"
	^ self normalizeLineWidth: metricBlock min: 0.5 max: 30
]

{ #category : #'public normalize line width' }
RWMetricNormalizer >> normalizeLineWidth: metricBlock min: min max: max [
	"metricBlock is a two arg block that accept the from model and the to model"
	^ self normalizeLineWidth: metricBlock min: min max: max using: #yourself
]

{ #category : #'public normalize line width' }
RWMetricNormalizer >> normalizeLineWidth: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation [
	| values |
	self checkNotEmpty.
	
	values := (self getNormalizedForLineWidthValues: metricBlock 
							min: min 
							max: max 
							minValue: minValue 
							maxValue: maxValue 
							using: transformation).
	self edges with: values do: [ :edge :v | edge shape width: v ] 
	
	
]

{ #category : #'public normalize line width' }
RWMetricNormalizer >> normalizeLineWidth: metricBlock min: min max: max using: transformation [
	"metricBlock is a two arg block that accept the from model and the to model"
	| e minValue maxValue |
	self checkNotEmpty.
	
	"We get the min and the max of the metric for all the edges"
	self edges ifEmpty: [ ^ self ].
	e := self edges anyOne.
	minValue := transformation rwValue: (metricBlock value: e from model value: e to model).
	maxValue := minValue.
	self edges do: [ :edge | 
		| t |  
		t := transformation rwValue: (metricBlock value: edge from model value: edge to model).
		minValue := minValue min: t.
		maxValue := maxValue max: t ].
	
	^ self normalizeLineWidth: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation
]

{ #category : #'public normalize position' }
RWMetricNormalizer >> normalizePosition: metricBlock min: minValue max: maxValue [
	"metricBlock is evaluated on each node model. 
	 minValue and maxValue are integer representing the minimum and maximum size in pixels for each node"
	self normalizePosition: metricBlock min: minValue max: maxValue using: #yourself
]

{ #category : #'public normalize position' }
RWMetricNormalizer >> normalizePosition: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation [
	"aBlock is evaluated on each node model"
	
	| values |
	values := (self getNormalizedValues: metricBlock 
							min: min max: max 
							minValue: minValue maxValue: maxValue 
							using: transformation).
	elements with: values do: [ :el :v | translator translate: el to: el position + (v asIntegerPoint) ] 

]

{ #category : #'public normalize position' }
RWMetricNormalizer >> normalizePosition: metricBlock min: min max: max using: transformation [
	"aBlock is evaluated on each node model"
	
	| minValue maxValue |
	"We get the min and the max of the metric for all the elements"
	minValue := transformation rwValue: (metricBlock rwValue: elements anyOne model).
	maxValue := minValue.
	elements do: [ :el | 
		| t |  
		t := transformation rwValue: (metricBlock rwValue: el model).
		minValue := minValue min: t.
		maxValue := maxValue max: t ].
	
	(maxValue - minValue) ~= (0 @ 0) ifTrue: [ 
		elements do: [ :el | 
			| tt t |
			t := transformation rwValue: (metricBlock rwValue: el model).
			"tt := minValue + (maxValue * (t - min) / max) asInteger."
			tt := min + ((max - min) * ( (t - minValue) / (maxValue - minValue))) asIntegerPoint.
			translator translate: el to: (tt) ] ] 

]

{ #category : #'public normalize size' }
RWMetricNormalizer >> normalizeSize: metricBlock [
	"metricBlock is evaluated on each node model. 
	 minValue and maxValue are integer representing the minimum and maximum size in pixels for each node"
	self normalizeSize: metricBlock min: 5 max: 30
]

{ #category : #'public normalize size' }
RWMetricNormalizer >> normalizeSize: metricBlock min: minValue max: maxValue [
	"metricBlock is evaluated on each node model. 
	 minValue and maxValue are integer representing the minimum and maximum size in pixels for each node"
	self normalizeSize: metricBlock min: minValue max: maxValue using: #yourself
]

{ #category : #'public normalize size' }
RWMetricNormalizer >> normalizeSize: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation [
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
]

{ #category : #'public normalize size' }
RWMetricNormalizer >> normalizeSize: metricBlock min: min max: max using: transformation [
	"aBlock is evaluated on each node model. 
	 Colors is an array of colors used to do the fading"
	
	| minValue maxValue |
	
	self checkNotEmpty.
	elements size <= 1 ifTrue: [ ^ self ].

	"We get the min and the max of the metric for all the elements"
	minValue := transformation rwValue: (metricBlock rwValue: elements anyOne model).
	maxValue := minValue.
	elements do: [ :el | 
		| t |  
		t := transformation rwValue: (metricBlock rwValue: el model).
		minValue := minValue min: t.
		maxValue := maxValue max: t ].
	
	self normalizeSize: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation
]

{ #category : #'public normalize size' }
RWMetricNormalizer >> normalizeSize: metricBlock using: transformation [
	"metricBlock is evaluated on each node model. 
	 minValue and maxValue are integer representing the minimum and maximum size in pixels for each node"
	self normalizeSize: metricBlock min: 5 max: 30 using: transformation
]

{ #category : #'public normalize x' }
RWMetricNormalizer >> normalizeTopLeftOfX: metricBlock [
	"metricBlock is evaluated on each node model"
	^ self normalizeTopLeftOfX: metricBlock min: 0 max: 200
]

{ #category : #'public normalize x' }
RWMetricNormalizer >> normalizeTopLeftOfX: metricBlock min: minValue max: maxValue [
	"metricBlock is evaluated on each node model. 
	 minValue and maxValue are integer representing the minimum and maximum size in pixels for each node"
	self normalizeTopLeftOfX: metricBlock min: minValue max: maxValue using: #yourself
]

{ #category : #'public normalize x' }
RWMetricNormalizer >> normalizeTopLeftOfX: metricBlock min: min max: max minValue: minValue maxValue: maxValue [ 
	"
	metricBlock is evaluated on each node model. 	

	min represent the X value of the minimum value.
	max represent the X value of the maximum value.
	
	minValue is the minimum value of the dataset.
	maxValue is the maximum value of the dataset.
	
	[ minValue ; maxValue ] is mapped to [ min ; max ]
	"
		
	self normalizeTopLeftOfX: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: #yourself
]

{ #category : #'public normalize x' }
RWMetricNormalizer >> normalizeTopLeftOfX: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation [
	"
	metricBlock is evaluated on each node model. 	

	min represent the X value of the minimum value.
	max represent the X value of the maximum value.
	
	minValue is the minimum value of the dataset.
	maxValue is the maximum value of the dataset.
	
	[ minValue ; maxValue ] is mapped to [ min ; max ]

	transformation is used to transform the metric value"
		
	(maxValue - minValue) ~= 0 ifTrue: [
		elements do: [ :el | 
			| tt t |
			t := transformation rwValue: (metricBlock rwValue: el model).
			tt := self getValue: t min: min max: max minValue: minValue maxValue: maxValue.
			translator translateTopLeftOf: el to: el encompassingRectangle topLeft + (tt @ 0) ] ] 
]

{ #category : #'public normalize x' }
RWMetricNormalizer >> normalizeTopLeftOfX: metricBlock min: min max: max minValue: minValue using: transformation [
	"metricBlock is evaluated on each node model. 	
	 min represent the X value of the minimum value.
	 max represent the X value of the maximum value.
	 transformation is used to transform the metric value"
	
	| maxValue |
	"We get the min and the max of the metric for all the elements"
	maxValue := transformation rwValue: (metricBlock rwValue: elements anyOne model).
	elements do: [ :el | 
		| t |  
		t := transformation rwValue: (metricBlock rwValue: el model).
		maxValue := maxValue max: t ].
	
	self normalizeTopLeftOfX: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation
]

{ #category : #'public normalize size' }
RWMetricNormalizer >> normalizeWidth: metricBlock [
	"metricBlock is evaluated on each node model."
	^ self normalizeWidth: metricBlock min: 5 max: 30
]

{ #category : #'public normalize size' }
RWMetricNormalizer >> normalizeWidth: metricBlock max: maxValue [
	"metricBlock is evaluated on each node model. 
	 maxValue is an integer representing the maximum size in pixels for each node"
	self normalizeWidth: metricBlock min: 5 max: maxValue
]

{ #category : #'public normalize size' }
RWMetricNormalizer >> normalizeWidth: metricBlock min: minValue max: maxValue [
	"metricBlock is evaluated on each node model. 
	 minValue and maxValue are integer representing the minimum and maximum size in pixels for each node"
	self normalizeWidth: metricBlock min: minValue max: maxValue using: #yourself
]

{ #category : #'public normalize size' }
RWMetricNormalizer >> normalizeWidth: metricBlock min: min max: max minValue: minValue [
	"aBlock is evaluated on each node model"
	
	^ self normalizeWidth: metricBlock min: min max: max minValue: minValue using: #yourself
]

{ #category : #'public normalize size' }
RWMetricNormalizer >> normalizeWidth: metricBlock min: min max: max minValue: minValue maxValue: maxValue [
	"aBlock is evaluated on each node model"
	
	^ self normalizeWidth: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: #yourself
]

{ #category : #'public normalize size' }
RWMetricNormalizer >> normalizeWidth: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation [
	"aBlock is evaluated on each node model. 
	 Colors is an array of colors used to do the fading"
		
	| values |
	self checkNotEmpty.	
	
	values := (self getNormalizedValues: metricBlock 
							min: min max: max 
							minValue: minValue maxValue: maxValue 
							using: transformation).
	elements with: values do: [ :el :v | el trachelShape width: v ] 

]

{ #category : #'public normalize size' }
RWMetricNormalizer >> normalizeWidth: metricBlock min: min max: max minValue: minValue using: transformation [
	"aBlock is evaluated on each node model"
	
	|  maxValue |
	
	self checkNotEmpty.

	"We get the max of the metric for all the elements"
	maxValue := transformation rwValue: (metricBlock rwValue: elements anyOne model).
	
	elements do: [ :el | 
		| t |  
		t := transformation rwValue: (metricBlock becomeForward Value: el model).
		maxValue := maxValue max: t ].

	self normalizeWidth: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation

]

{ #category : #'public normalize size' }
RWMetricNormalizer >> normalizeWidth: metricBlock min: min max: max using: transformation [
	"aBlock is evaluated on each node model. 
	 Colors is an array of colors used to do the fading"
	
	| minValue maxValue |
	
	self checkNotEmpty.

	"We get the min and the max of the metric for all the elements"
	minValue := transformation rwValue: (metricBlock rwValue: elements anyOne model).
	maxValue := minValue.
	elements do: [ :el | 
		| t |  
		t := transformation rwValue: (metricBlock rwValue: el model).
		minValue := minValue min: t.
		maxValue := maxValue max: t ].
	
	
	self normalizeWidth: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation.
	
]

{ #category : #'public normalize x' }
RWMetricNormalizer >> normalizeX: metricBlock [
	"metricBlock is evaluated on each node model"
	^ self normalizeX: metricBlock min: 0 max: 200
]

{ #category : #'public normalize x' }
RWMetricNormalizer >> normalizeX: metricBlock min: minValue max: maxValue [
	"metricBlock is evaluated on each node model. 
	 minValue and maxValue are integer representing the minimum and maximum size in pixels for each node"
	self normalizeX: metricBlock min: minValue max: maxValue using: #yourself
]

{ #category : #'public normalize x' }
RWMetricNormalizer >> normalizeX: metricBlock min: min max: max minValue: minValue [
	"metricBlock is evaluated on each node model. 	
	 min represent the X value of the minimum value.
	 max represent the X value of the maximum value.
	 transformation is used to transform the metric value"
	
	^ self normalizeX: metricBlock min: min max: max minValue: minValue using: #yourself
]

{ #category : #'public normalize x' }
RWMetricNormalizer >> normalizeX: metricBlock min: min max: max minValue: minValue maxValue: maxValue [ 
	"
	metricBlock is evaluated on each node model. 	

	min represent the X value of the minimum value.
	max represent the X value of the maximum value.
	
	minValue is the minimum value of the dataset.
	maxValue is the maximum value of the dataset.
	
	[ minValue ; maxValue ] is mapped to [ min ; max ]
	"
		
	self normalizeX: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: #yourself
]

{ #category : #'public normalize x' }
RWMetricNormalizer >> normalizeX: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation [
	"
	metricBlock is evaluated on each node model. 	

	min represent the X value of the minimum value.
	max represent the X value of the maximum value.
	
	minValue is the minimum value of the dataset.
	maxValue is the maximum value of the dataset.
	
	[ minValue ; maxValue ] is mapped to [ min ; max ]

	transformation is used to transform the metric value"
		
	(maxValue - minValue) ~= 0 ifTrue: [
		elements do: [ :el | 
			| tt t |
			t := transformation rwValue: (metricBlock rwValue: el model).
			tt := self getValue: t min: min max: max minValue: minValue maxValue: maxValue.
			translator translate: el to: el position + (WMVector3F x: tt asFloat y: 0.0 z: 0.0) ] ] 
]

{ #category : #'public normalize x' }
RWMetricNormalizer >> normalizeX: metricBlock min: min max: max minValue: minValue using: transformation [
	"metricBlock is evaluated on each node model. 	
	 min represent the X value of the minimum value.
	 max represent the X value of the maximum value.
	 transformation is used to transform the metric value"
	
	| maxValue |
	"We get the min and the max of the metric for all the elements"
	maxValue := transformation rwValue: (metricBlock rwValue: elements anyOne model).
	elements do: [ :el | 
		| t |  
		t := transformation rwValue: (metricBlock rwValue: el model).
		maxValue := maxValue max: t ].
	
	self normalizeX: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation
]

{ #category : #'public normalize x' }
RWMetricNormalizer >> normalizeX: metricBlock min: min max: max using: transformation [
	"metricBlock is evaluated on each node model. 	
	 min represent the X value of the minimum value.
	 max represent the X value of the maximum value.
	 transformation is used to transform the metric value"
	
	| minValue maxValue |
	"We get the min and the max of the metric for all the elements"
	minValue := transformation rwValue: (metricBlock rwValue: elements anyOne model).
	maxValue := minValue.
	elements do: [ :el | 
		| t |  
		t := transformation rwValue: (metricBlock rwValue: el model).
		minValue := minValue min: t.
		maxValue := maxValue max: t ].
	
	self normalizeX: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation
]

{ #category : #'public normalize y' }
RWMetricNormalizer >> normalizeY: metricBlock min: minValue max: maxValue [
	"metricBlock is evaluated on each node model. 
	 minValue and maxValue are integer representing the minimum and maximum size in pixels for each node"
	self normalizeY: metricBlock min: minValue max: maxValue using: #yourself
]

{ #category : #'public normalize y' }
RWMetricNormalizer >> normalizeY: metricBlock min: min max: max minValue: minValue [
	"metricBlock is evaluated on each node model. 	
	 min represent the X value of the minimum value.
	 max represent the X value of the maximum value.
	 transformation is used to transform the metric value"
	
	^ self normalizeY: metricBlock min: min max: max minValue: minValue using: #yourself
]

{ #category : #'public normalize y' }
RWMetricNormalizer >> normalizeY: metricBlock min: min max: max minValue: minValue maxValue: maxValue [ 
	"
	metricBlock is evaluated on each node model. 	

	min represent the X value of the minimum value.
	max represent the X value of the maximum value.
	
	minValue is the minimum value of the dataset.
	maxValue is the maximum value of the dataset.
	
	[ minValue ; maxValue ] is mapped to [ min ; max ]
	"
		
	self normalizeY: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: #yourself
]

{ #category : #'public normalize y' }
RWMetricNormalizer >> normalizeY: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation [
	"
	metricBlock is evaluated on each node model. 	

	min represent the Y value of the minimum value.
	max represent the Y value of the maximum value.
	
	minValue is the minimum value of the dataset.
	maxValue is the maximum value of the dataset.
	
	[ minValue ; maxValue ] is mapped to [ min ; max ]

	transformation is used to transform the metric value"
		
	(maxValue - minValue) ~= 0 ifTrue: [
		elements do: [ :el | 
			| tt t |
			t := transformation rwValue: (metricBlock rwValue: el model).
			tt := self getValue: t min: min max: max minValue: minValue maxValue: maxValue.
			translator translate: el to: el position + (WMVector3F x: 0.0 y: tt asFloat z: 0.0) ] ] 
]

{ #category : #'public normalize y' }
RWMetricNormalizer >> normalizeY: metricBlock min: min max: max minValue: minValue using: transformation [
	"metricBlock is evaluated on each node model. 	
	 min represent the X value of the minimum value.
	 max represent the X value of the maximum value.
	 transformation is used to transform the metric value"
	
	| maxValue |
	"We get the min and the max of the metric for all the elements"
	maxValue := transformation rwValue: (metricBlock rwValue: elements anyOne model).
	elements do: [ :el | 
		| t |  
		t := transformation rwValue: (metricBlock rwValue: el model).
		maxValue := maxValue max: t ].
	
	self normalizeY: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation
]

{ #category : #'public normalize y' }
RWMetricNormalizer >> normalizeY: metricBlock min: min max: max using: transformation [
	"metricBlock is evaluated on each node model. 	
	 min represent the X value of the minimum value.
	 max represent the X value of the maximum value.
	 transformation is used to transform the metric value"
	
	| minValue maxValue |
	"We get the min and the max of the metric for all the elements"
	maxValue := transformation rwValue: (metricBlock rwValue: elements anyOne model).
	minValue := maxValue.
	
	elements do: [ :el | 
		| t |  
		t := transformation rwValue: (metricBlock rwValue: el model).
		minValue := minValue min: t.
		maxValue := maxValue max: t ].
	
	self normalizeY: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation
]

{ #category : #'public normalize y' }
RWMetricNormalizer >> normalizeZ: metricBlock min: minValue max: maxValue [
	"metricBlock is evaluated on each node model. 
	 minValue and maxValue are integer representing the minimum and maximum size in pixels for each node"
	self normalizeZ: metricBlock min: minValue max: maxValue using: #yourself
]

{ #category : #'public normalize y' }
RWMetricNormalizer >> normalizeZ: metricBlock min: min max: max minValue: minValue [
	"metricBlock is evaluated on each node model. 	
	 min represent the X value of the minimum value.
	 max represent the X value of the maximum value.
	 transformation is used to transform the metric value"
	
	^ self normalizeZ: metricBlock min: min max: max minValue: minValue using: #yourself
]

{ #category : #'public normalize y' }
RWMetricNormalizer >> normalizeZ: metricBlock min: min max: max minValue: minValue maxValue: maxValue [ 
	"
	metricBlock is evaluated on each node model. 	

	min represent the X value of the minimum value.
	max represent the X value of the maximum value.
	
	minValue is the minimum value of the dataset.
	maxValue is the maximum value of the dataset.
	
	[ minValue ; maxValue ] is mapped to [ min ; max ]
	"
		
	self normalizeZ: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: #yourself
]

{ #category : #'public normalize y' }
RWMetricNormalizer >> normalizeZ: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation [
	"
	metricBlock is evaluated on each node model. 	

	min represent the Y value of the minimum value.
	max represent the Y value of the maximum value.
	
	minValue is the minimum value of the dataset.
	maxValue is the maximum value of the dataset.
	
	[ minValue ; maxValue ] is mapped to [ min ; max ]

	transformation is used to transform the metric value"
		
	(maxValue - minValue) ~= 0 ifTrue: [
		elements do: [ :el | 
			| tt t |
			t := transformation rwValue: (metricBlock rwValue: el model).
			tt := self getValue: t min: min max: max minValue: minValue maxValue: maxValue.
			translator translate: el to: el position + (WMVector3F x: 0.0 y: 0.0 z: tt asFloat) ] ] 
]

{ #category : #'public normalize y' }
RWMetricNormalizer >> normalizeZ: metricBlock min: min max: max minValue: minValue using: transformation [
	"metricBlock is evaluated on each node model. 	
	 min represent the X value of the minimum value.
	 max represent the X value of the maximum value.
	 transformation is used to transform the metric value"
	
	| maxValue |
	"We get the min and the max of the metric for all the elements"
	maxValue := transformation rwValue: (metricBlock rwValue: elements anyOne model).
	elements do: [ :el | 
		| t |  
		t := transformation rwValue: (metricBlock rwValue: el model).
		maxValue := maxValue max: t ].
	
	self normalizeZ: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation
]

{ #category : #'public normalize y' }
RWMetricNormalizer >> normalizeZ: metricBlock min: min max: max using: transformation [
	"metricBlock is evaluated on each node model. 	
	 min represent the X value of the minimum value.
	 max represent the X value of the maximum value.
	 transformation is used to transform the metric value"
	
	| minValue maxValue |
	"We get the min and the max of the metric for all the elements"
	maxValue := transformation rwValue: (metricBlock rwValue: elements anyOne model).
	minValue := maxValue.
	
	elements do: [ :el | 
		| t |  
		t := transformation rwValue: (metricBlock rwValue: el model).
		minValue := minValue min: t.
		maxValue := maxValue max: t ].
	
	self normalizeZ: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation
]

{ #category : #accessing }
RWMetricNormalizer >> objects: someObjects [
	self assert: [ view notNil ] description: 'A view has to be set'.
	
	self elements: (self view elementsFromModels: someObjects)
]

{ #category : #'public translation' }
RWMetricNormalizer >> smoothTranslation [
	translator := RTSmoothLayoutTranslator new
]

{ #category : #accessing }
RWMetricNormalizer >> view [
	^ view
]

{ #category : #accessing }
RWMetricNormalizer >> view: anObject [
	view := anObject
]
