Class {
	#name : #VTLContext,
	#superclass : #Object,
	#instVars : [
		'position'
	],
	#category : #'VTL-Core'
}

{ #category : #accessing }
VTLContext class >> position: anInteger [

	^ self new
		  position: anInteger;
		  yourself
]

{ #category : #accessing }
VTLContext >> byteIn: aMemory [

	^ aMemory byteAt: position
]

{ #category : #accessing }
VTLContext >> decrement [

	^ position := position - 1
]

{ #category : #accessing }
VTLContext >> increment [

	^ position := position + 1
]

{ #category : #accessing }
VTLContext >> position [

	^ position
]

{ #category : #accessing }
VTLContext >> position: anObject [

	position := anObject
]

{ #category : #printing }
VTLContext >> printOn: aStream [

	aStream
		nextPutAll: 'Context[';
		nextPutAll: position asString;
		nextPut: $]
]
