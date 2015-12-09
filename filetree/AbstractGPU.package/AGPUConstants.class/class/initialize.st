initialize
initialize
"
	self initialize
"
	super initialize.


    self data pairsDo: [:k :v |
        self writeClassVariableNamed: k value: v
    ]
