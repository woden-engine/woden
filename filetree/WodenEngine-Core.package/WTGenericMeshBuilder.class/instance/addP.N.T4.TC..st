adding
addP: position N: normal T4: tangent4 TC: texcoord
	vertices add: (WTGenericVertexF new
		position: position;
		normal: normal;
		tangent4: tangent4;
		texcoord: texcoord;
		color: currentColor;
		yourself)