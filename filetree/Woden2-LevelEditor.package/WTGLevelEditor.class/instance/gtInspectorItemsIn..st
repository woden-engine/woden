inspector
gtInspectorItemsIn: composite
	<gtInspectorPresentationOrder: 0> 
		^ (composite list)
			title: 'Selected elements';
			display: [ :aCollection | selection elements ]