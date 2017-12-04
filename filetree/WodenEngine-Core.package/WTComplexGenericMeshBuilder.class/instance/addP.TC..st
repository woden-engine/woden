adding
addP: position TC: texcoord
	vertices add: (WTGenericVertexF new
		position: (transform transformPosition3: position);
		texcoord: texcoord;
		color: currentColor;
		yourself)