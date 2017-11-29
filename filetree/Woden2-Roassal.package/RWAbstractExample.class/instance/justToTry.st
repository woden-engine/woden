installing
justToTry


	
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
	