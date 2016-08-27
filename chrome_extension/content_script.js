
chrome.runtime.onMessage.addListener(function (request, sender, sendResponse){
  if (request.action == "PO::getDomRequest"){
    debugger
    sendResponse({DOM: document.documentElement});
  }
});
  
