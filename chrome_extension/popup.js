
function loadContentScript() {
  chrome.tabs.executeScript(null, {file: "content_script.js"});
}

function init() {
  PO.init().then(function(){
    loadContentScript();
  });
}

init();

chrome.tabs.query({active: true, currentWindow: true}, function(tabs) {
  chrome.tabs.sendMessage(tabs[0].id, {action: "PO::getDomRequest"}, function(response) {
    window.DOM = response.DOM;
  });
});