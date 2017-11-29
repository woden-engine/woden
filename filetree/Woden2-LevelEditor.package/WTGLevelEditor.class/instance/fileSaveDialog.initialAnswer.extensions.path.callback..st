dialogs
fileSaveDialog: title initialAnswer: fileName extensions: extensions path: path callback: callback
	| dialog |
	dialog := FileDialogWindow new
		extent: 640@480;
		title: title;
		fileNameText: fileName;
		answerSaveFile.
	extensions ifNotNil: [dialog validExtensions: extensions].
	path ifNotNil: [dialog selectPathName: path].
	dialog openInExternalWindowModalCallback: [ callback value: dialog answer ]