// Generated by CoffeeScript 1.10.0
var config, firebaseGet, firebaseGetArr, firebasePush, firebaseRemove, firebaseSet, firebaseSignIn, getValues, logFn;

config = {
  apiKey: Credentials.apiKey,
  authDomain: Credentials.authDomain,
  databaseURL: Credentials.databaseURL,
  storageBucket: Credentials.storageBucket
};

firebaseSignIn = function(callback) {
  var email, password;
  email = Credentials.email;
  password = Credentials.password;
  return firebase.auth().signInWithEmailAndPassword(email, password);
};

firebaseGet = function(key) {
  var ref;
  return ref = firebase.database().ref(key).once("value").then(function(result) {
    return result.val();
  });
};

firebaseSet = function(key, val) {
  return firebase.database().ref(key).set(val);
};

firebasePush = function(key, val) {
  var ref;
  ref = firebase.database().ref(key).push();
  return ref.set(val).then(function() {
    return ref.key;
  });
};

firebaseGetArr = function(key) {
  return firebaseGet(key).then(function(result) {
    return getValues(result);
  });
};

firebaseRemove = function(key) {
  return firebase.database().ref(key).remove();
};

logFn = function(val) {
  return console.log(val);
};

getValues = function(obj) {
  if (obj && (typeof obj === 'object') && !(Array.isArray(obj))) {
    return Object.keys(obj).map(function(key) {
      return obj[key];
    });
  } else {
    return obj;
  }
};
