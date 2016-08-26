# persistent_override

_a self-hosted browser userscript system with a database_

---

### Purpose

Sometimes when browsing the web I'll add a custom Javascript function in the dev tools console.

These functions will be lost if I navigate away from the page.

This library enables persisting these scripts.

It does this by leveraging [firebase](firebase.google.com).

It uses a Firebase database to store and send the scripts.

This same database is made accessible to the website as a generic data store.

### How it works

This entire library is packaged into a bookmarklet. Clicking it will load up the following scripts (coffeescript is compiled to javascript), which are bundled into a single file [dist/persistent_override.pkgd.js](./dist/persistent_override.pkgd.js)

- dependencies (minified javascript)
  - [src/firebase.min.js](./src/firebase.min.js) (Firebase)[http://firebase.google.com]
  - [src/curry.min.js](./src/curry.min.js) (Curry)[https://github.com/dominictarr/curry]
  - [src/toSource.min.js](./src/toSource.min.js) (Object.toSource polyfill)[https://github.com/oliver-moran/toSource.js]

- app (coffeescript compiled to minified javascript)
  - [src/start_firebase.coffee](./src/start_firebase.coffee) (firebase helpers)
  - [src/persistent_override.coffee](./src/persistent_override.coffee) (main API)

With these loaded, you can go into the dev tools console and define userscripts.

Here's an example of using the API for adding scripts:

