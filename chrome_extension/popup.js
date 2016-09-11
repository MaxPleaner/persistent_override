Helpers = {
  ChromeExtension: function(){
    this.sendMessage = function (actionName, messageData, callback) {
      chrome.tabs.query({active: true, currentWindow: true}, function(tabs){
        data = Object.assign({ action: actionName }, messageData);
        requestData = (JSON.stringify(data));
        chrome.tabs.sendMessage(tabs[0].id, requestData, callback);
      });
    };
    this.sendContentScript = function(){
      chrome.tabs.executeScript(
        null, {file: "content_script.pkgd.js"}
      );
    };
    this.init = function() {
      this.sendContentScript();
    };
    return this;
  }(),
  DOM: function(){
    this.newScriptFormListener = function() {
      $("#show-new-script-form").off("click").on("click", function(e){
        var $el = $(e.currentTarget);
        if ($el.hasClass("showing")) {
          $el.text("Show new script form")
        } else {
          $el.text("Hide new script form")
        }
        $el.toggleClass("showing")
        $("#new-script").toggleClass("hidden")
      })
    };
    this.currentSiteCheckbox = function() {
      $("#for-current-site-checkbox").off("click").on("click", function(e){
        var $el = $(e.currentTarget);
        var willBeUnchecked = $el.attr("isChecked") == "true"
        if (willBeUnchecked) {
          $el.attr("isChecked", "false")
        } else {
          $el.attr("isChecked", "true")
        }
        $("#regex-input").toggleClass("hidden")
        return true;
      })
    }
    this.onScriptCreate = function() {
      $("#new-script").off("submit").on("submit", function(e){
        var $el = $(e.currentTarget);
        isSiteSpecific = $el.find("#for-current-site-checkbox").attr("isChecked") == "true"
        var scriptData = {
          matcher: {
            isSiteSpecific: isSiteSpecific,
            hasRegex: !isSiteSpecific && $el.find("#regex-input").val()
          },
          content: $el.find("#script-content").text()
        }
        Helpers.ChromeExtension.sendMessage("createScript", scriptData, function(response){
          console.log(response)
        })
        return false;
      })
    }
    this.init = function() {
      this.newScriptFormListener();
      this.currentSiteCheckbox();
      this.onScriptCreate();
    }
    return this;
  }()
};

$(function(){
  Helpers.ChromeExtension.init();
  Helpers.DOM.init()
})

