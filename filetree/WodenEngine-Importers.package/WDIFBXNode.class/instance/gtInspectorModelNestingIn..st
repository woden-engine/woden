gt inspector extensions
gtInspectorModelNestingIn: composite
	<gtInspectorPresentationOrder: 0>
	composite tree 
		title: 'Nodes';
		display: [ :root | root ];
		children: [ :each | each children ];
		format: [ :node | node type ]