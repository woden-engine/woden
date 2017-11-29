rendering
createToolBar
	| toolbar |
	toolbar := BrHBoxPane new
		constraintsDo:[:c| c hMatchParent; vFitContent; alignCenter];
		background:(BlBackground fill: Color lightGray).
	toolbar addChild: (self createToolbarButtonLabel: 'Open' action: [:evt | self open ]).
	toolbar addChild: (self createToolbarButtonLabel: 'Save' action: [:evt | self save ]).
	toolbar addChild: (self createToolbarButtonLabel: 'Save As' action: [:evt | self saveAs ]).
	toolbar addChild: (self createToolbarButtonLabel: 'Inspect' action: [:evt | self inspectSelection ]).
	toolbar addChild: (self createToolbarButtonLabel: 'Texture Transform' action: [:evt | self openTextureTransformEditor ]).
	toolbar addChild: (self createToolbarButtonLabel: 'Subtract' action: [:evt | self subtractSelectedBrushes ]).
	toolbar addChild: (self createToolbarButtonLabel: 'Make Brush Entity' action: [:evt | self makeBrushEntity ]).

	^ toolbar