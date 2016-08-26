config =
  apiKey:        Credentials.apiKey
  authDomain:    Credentials.authDomain
  databaseURL:   Credentials.databaseURL
  storageBucket: Credentials.storageBucket

firebaseSignIn = (callback) ->
  # returns promise
  email = Credentials.email
  password = Credentials.password
  firebase.auth().signInWithEmailAndPassword email, password

firebaseGet = (key) ->
  # returns promise
  ref = firebase.database().ref(key).once("value").then (result) -> result.val()

firebaseSet = (key, val) ->
  # returns promise
  firebase.database().ref(key).set(val)

firebasePush = (key, val) ->
  # returns promise
  ref = firebase.database().ref(key).push()
  ref.set(val).then () -> ref.key

firebaseGetArr = (key) ->
  # returns promise
  firebaseGet(key).then (result) -> getValues result
  
firebaseRemove = (key) ->
  # returns promise
  firebase.database().ref(key).remove()

logFn = (val) ->
  # fn passed to then/catch
  console.log(val)

getValues = (obj) ->
  # get values of a hash
  # Object.values won't necessarily be defined in the browser
  # this is a 'safe' method - it will have no effect unless obj is a hash
  if obj && (typeof(obj) == 'object') && !(Array.isArray(obj))
    Object.keys(obj).map (key) -> obj[key]
  else
    obj
    
    
