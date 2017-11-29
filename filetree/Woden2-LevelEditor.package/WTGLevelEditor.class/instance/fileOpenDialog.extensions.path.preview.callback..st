dialogs
fileOpenDialog: title extensions: extensions path: path preview: preview callback: callback
	| dialog |
	dialog := FileDialogWindow new
		title: title;
		previewType: preview;
		initialize;
		title: title;
		answerPathName.
	extensions ifNotNil: [dialog validExtensions: extensions].
	path ifNotNil: [dialog selectPathName: path].
	dialog extent: 640@480;
		openInExternalWindowModalCallback: [ callback value: dialog answer ]