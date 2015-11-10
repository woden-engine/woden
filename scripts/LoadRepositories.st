FileStream stdout nextPutAll: 'Loading FileTree'; lf.

Metacello new
	baseline: 'FileTree';
	repository: 'github://dalehenrich/filetree:issue_161/repository';
	load: 'MonticelloFileTree-Git'.

"Load Woden 2"
FileStream stdout nextPutAll: 'Loading Woden2'; lf.
FileStream stdout nextPutAll: 'TODO'; lf.

"
Author useAuthor: 'LoadWoden2' during: [ 
	Gofer new
		url: 'gitfiletree://../filetree';
		package: 'Woden2-Core';
		load.	
	"(Smalltalk at: #ConfigurationOfWoden2) loadGit"
].
"

"Save the image"
(Smalltalk saveAs: 'woden') 
    ifFalse: [ Smalltalk snapshot: false andQuit: true ].

