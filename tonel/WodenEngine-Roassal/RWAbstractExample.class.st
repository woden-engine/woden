Class {
	#name : #RWAbstractExample,
	#superclass : #RWObject,
	#category : 'WodenEngine-Roassal-Examples'
}

{ #category : #gtinspector }
RWAbstractExample class >> gtExamplesProvider [
	^ self new
]

{ #category : #gtinspector }
RWAbstractExample class >> gtInspectorPreviewIn: composite [
	<gtInspectorPresentationOrder: 4>
	<gtInspectorTag: #examples>
	^ self new gtInspectorPreviewIn: composite
]

{ #category : #'instance creation' }
RWAbstractExample >> gtOpenOn: v [
	|  icon64Mime form element  |

	self gtExamples do: [ :anExample |
		icon64Mime := self perform: (anExample method selector, #Icon) asSymbol.
		form := TRPlatform current formClass fromBinaryStream: 
							(TRPlatform current mimeDecodeToBytes: icon64Mime readStream).
		element := (RTBitmap new form: form) elementOn: anExample.
		element @ (RTPopup new text: anExample method selector asString).
		element @ (RTEventForwarder new eventClass: TRMouseDragging). 
		v add: element ].

	RTGridLayout new on: v elements.
	
]

{ #category : #installing }
RWAbstractExample >> installOn: aView [
	| el |
	el := (RTLabel new text: (self label)) element.
	el @ RTHighlightable.
	aView add: el.
	
	el when: TRMouseClick do: [ :evt |
		aView clean.
		self openOn: aView.
		aView canvas camera focusOnCenter.
	].

]

{ #category : #installing }
RWAbstractExample >> installTitle: aTitle code: sourceCode [
	"SourceCode should be a complete example, executable within a workspace"
	
	| viewOrBuilder  icon64Mime stream window viewWindow | 
	viewOrBuilder := (Compiler evaluate: sourceCode).
	
	viewWindow := RWViewWindow new.
	viewWindow view: viewOrBuilder.
	window := viewWindow openInMorphic.
		
"	canvas morph ifNil: [ self error: 'You have forgotten to open the view!' ].
"	
	(self class methodDict includesKey: ('example', aTitle) asSymbol)
		ifTrue: [ self error: 'Title already used. Proceed to override' ].
	
	self class compile: 'example', aTitle, String cr, sourceCode classified: 'sources'.
	
	stream := WriteStream on: ByteArray new.
	TRPlatform current pngReadWriterClass
				putForm: (window imageForm scaledToSize: 100 @ 100)
				onStream: stream .
	icon64Mime := (TRPlatform current mimeEncode: stream contents readStream) contents.
	self class compile: 'example', aTitle, 'Icon', String cr, '	^ ''', icon64Mime, '''' classified: 'icons'.
	window delete.
]

{ #category : #installing }
RWAbstractExample >> justToTry [


	
	RTGrapherExample new installTitle: 'ForceLayoutWithGreatCharge' 
		code:
		'


	| b |
	b := RTGraphBuilder new.
	b nodes
		shape: (RTEllipse new size: #numberOfMethods);
		whenOverShowEdges: [ :cls | cls dependentClasses ].

	b edges
		connectTo: [ :c | c subclasses ];
		shape: (RTLine new color: Color gray).

	b layout 
		use: (RTForceBasedLayout new charge: -180).

	b global
		minSize: 10;
		normalizeColor: [ :cls | cls methods size ] using: (Array with: Color green with: Color red).

	b addAll: (RTObject withAllSubclasses).
	b open.
	b view canvas'
	
]

{ #category : #accessing }
RWAbstractExample >> label [
	^ 'fill please'
]

{ #category : #'instance creation' }
RWAbstractExample >> open [

	| v |
	v := RTView new.
	v @ RTDraggableView.
	self openOn: v.
	v open.
	
]

{ #category : #'instance creation' }
RWAbstractExample >> openOn: v [

	| exampleSymbols icon64Mime form element  helpBar |

	exampleSymbols := self class selectors 
								select: [ :symbol | (symbol beginsWith: 'example') 
															and: [ (symbol endsWith: 'Icon') not ] ].
	exampleSymbols do: [ :k |
		icon64Mime := self perform: (k, #Icon) asSymbol.
		form := TRPlatform current formClass fromBinaryStream: 
							(TRPlatform current mimeDecodeToBytes: icon64Mime readStream).
		element := (RTBitmap new form: form) element.
		element @ (RTPopup new text: k asString).
		element when: TRMouseLeftClick do: [ :evt | self class new perform: k ].
		element when: TRMouseRightClick do: [ :evt | (self class >> k) browse ].
		element @ (RTEventForwarder new eventClass: TRMouseDragging). 
		v add: element.
	].

	RTGridLayout new on: v elements.
	
	v canvas addMenu: 'back' callback: [ self pressedBackButtonOn: v ].
	helpBar := TRLabelShape new text: ' Left to run / Right for code'.
	v canvas addFixedShape: helpBar.
	TRConstraint stickAtTheBottomOfTheWindow: helpBar.
	
]
