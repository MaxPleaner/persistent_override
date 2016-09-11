// function addMessageListener(actionName, callback){
//   // request is passed to callback, which should call sendResponse
//   chrome.runtime.onMessage.addListener(function (request, sender, sendResponse){
//     sendResponse("foo")
//     request = JSON.parse(request);

//     if (request.action == actionName){
//       callback(request);
//     }
//   });
// }



// addMessageListener("createScript", function(request){
// sendResponse({foo: "bar"})
// })


  chrome.runtime.onMessage.addListener(function (request, sender, sendResponse){
    sendResponse("foo")
  })