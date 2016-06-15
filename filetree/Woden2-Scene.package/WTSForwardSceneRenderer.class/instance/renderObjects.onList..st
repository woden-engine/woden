rendering
renderObjects: objects onList: commandList
	objects do: [ :object | object renderOn: commandList mode: #forward]