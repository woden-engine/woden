hooks
createBaseShapeNode
	| baseNode renderable vertexBuffer indexBuffer subMesh |
	baseNode := WDSceneNode new.
	renderable := WDCompositeMeshRenderable new.
	vertexBuffer := WDVertexBuffer for: WDLineVertex withCapacity: 1024.
	indexBuffer := WDIndexBuffer forUInt32: 1024.
	renderable addVertexBuffer: vertexBuffer;
		indexBuffer: indexBuffer.
	subMesh := WDSubMesh new
		startIndex: 0;
		indexCount: 0;
		primitiveType: WDMeshPrimitiveType lines;
		material: WDPlainColorMaterial new.
	renderable addSubMesh: subMesh.
	
	baseNode attach: renderable.
	^ baseNode