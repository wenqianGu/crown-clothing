# Asynchronous stream of events. 
* user click stream with different time interval 
* We are able to react to each of these events inside 
## Listener class 
* Listener is just a class or some kind of object that has three key methods on it. 
* next is called everytime a new event in the stream happens. 
    * next is really just poiting to our callback, which is really what that callback was when we passed to on /off state change.
```jsx
next : (nextval) => {do sth with val},
error: (error) => {do something with error},
complete: () => {do sth when finished.}
```
## subscription 
* The subscription is really just saying, hey, let me start listening what happens in the stream. 
* you can listen at any point when the stream is going, 
    * maybe, we are listening at the start of the stream, meaning no events have triggered. 
    