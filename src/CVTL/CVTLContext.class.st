Class {
	#name : #CVTLContext,
	#superclass : #Object,
	#instVars : [
		'position'
	],
	#category : #'CVTL-Core'
}

{ #category : #accessing }
CVTLContext class >> pos: anInteger [

	^ self new
		  position: anInteger;
		  yourself
]

{ #category : #accessing }
CVTLContext >> byteIn: aMemory [

	^ aMemory byteAt: position
]

{ #category : #accessing }
CVTLContext >> decrement [

	^ position := position - 1
]

{ #category : #accessing }
CVTLContext >> increment [

	^ position := position + 1
]

{ #category : #accessing }
CVTLContext >> position [

	^ position
]

{ #category : #accessing }
CVTLContext >> position: anObject [

	position := anObject
]

{ #category : #printing }
CVTLContext >> printOn: aStream [

	aStream
		nextPutAll: 'Context[';
		nextPutAll: position asString;
		nextPut: $]
]
