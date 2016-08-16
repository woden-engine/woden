menu
menuCommandOn: aBuilder
	<worldMenu>
	((aBuilder item: #Roassal3d) icon: RTIcon smallRoassal)
	withSeparatorAfter;
	with: [
		(aBuilder item: #'Roassal 3D Examples')
			order: 0.1; 
			parent: #Roassal3d;
			label: 'Roassal 3D examples';
			icon: self smallRoassal;
			action: [ self new open ] ]