rendering
renderObjects: objects filter: viewportFilter onList: commandList submode: submode
	objects select: viewportFilter thenDo: [ :object | object renderOn: commandList mode: #forward submode: submode]