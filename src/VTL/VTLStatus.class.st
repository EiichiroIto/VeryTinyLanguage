Class {
	#name : #VTLStatus,
	#superclass : #Object,
	#instVars : [
		'state',
		'topOfLine',
		'position'
	],
	#category : #'VTL-Core'
}

{ #category : #accessing }
VTLStatus >> bePrompted [

	state := #prompted.
	^ self
]

{ #category : #accessing }
VTLStatus >> beStepping [

	state := #stepping.
	^ self
]

{ #category : #initialization }
VTLStatus >> initialize [

	self bePrompted
]

{ #category : #testing }
VTLStatus >> isPrompted [

	^ state = #prompted
]

{ #category : #testing }
VTLStatus >> isStepping [

	^ state = #stepping
]

{ #category : #accessing }
VTLStatus >> position [

	^ position
]

{ #category : #accessing }
VTLStatus >> position: anInteger [

	position := anInteger
]

{ #category : #printing }
VTLStatus >> printOn: aStream [

	aStream
		nextPutAll: 'Status[state=';
		nextPutAll: state asString;
		nextPutAll: ',position=';
		nextPutAll: position asString;
		nextPutAll: ',topOfLine=';
		nextPutAll: topOfLine asString;
		nextPut: $]
]

{ #category : #accessing }
VTLStatus >> state [

	^ state
]

{ #category : #accessing }
VTLStatus >> state: anObject [

	state := anObject
]

{ #category : #accessing }
VTLStatus >> topOfLine [

	^ topOfLine
]

{ #category : #accessing }
VTLStatus >> topOfLine: anObject [

	topOfLine := anObject
]
