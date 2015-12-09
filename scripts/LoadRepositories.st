FileStream stdout nextPutAll: 'Loading FileTree'; lf.

Metacello new
	baseline: 'FileTree';
	repository: 'github://dalehenrich/filetree:issue_161/repository';
	load: 'MonticelloFileTree-Git'.

"Load Abstract GPU bindings"
FileStream stdout nextPutAll: 'Loading Woden2'; lf.
Metacello new
	baseline: 'AbstractGPU';
	repository: 'gitfiletree://filetree';
	load.

"Load Woden 2"
FileStream stdout nextPutAll: 'Loading Woden2'; lf.
Metacello new
	baseline: 'Woden2';
	repository: 'gitfiletree://filetree';
	load.

"Save the image"
(Smalltalk saveAs: 'woden2') 
    ifFalse: [ Smalltalk snapshot: false andQuit: true ].

