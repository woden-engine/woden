adding
addP: position N: normal TC: texcoord
	vertices add: (WTGenericVertexF new
		position: (transform transformPosition3: position);
		normal: (transform transformNormal: normal);
		texcoord: texcoord;
		color: currentColor;
		yourself)