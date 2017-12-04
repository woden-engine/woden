modifiers
combineSubmeshes
	submeshes := {WTModelSubmesh new
		firstIndex: 0;
		indexCount: indices size;
		primitiveType: AGPU_TRIANGLES;
		material: submeshes first material;
		yourself
	}