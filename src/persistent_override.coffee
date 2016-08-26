PersistentOverride =
  
  clear: () ->
    firebaseRemove("regexes")
    firebaseRemove("sourceCode")
  
  defineScript: (object, regex) ->
    # returns promise which is passed paths to the new db records
    regexStr = regex.toString()
    scriptSrc = object.toSource()
    firebasePush("sourceCode", scriptSrc).then (sourceKey) ->
      regexObj = regex: regexStr, sourceKey: sourceKey
      firebasePush("regexes", regexObj).then (regexKey) ->
        ["sourceCode/#{sourceKey}", "regexes/#{regexKey}"]
        
  defineScriptForCurrentSite: (object) ->
    curriedFn = curry(PO.defineScript)(object)
    PO.forCurrentSite(curriedFn)
    
  getScriptsForCurrentSite: () ->
    PO.getScriptsForSite(PO.getCorrectLocationOrigin())
    
  getScriptsForSite: (sitename) ->
    # returns list of hashes with signature:
    #   regex: regex as string
    #   scriptSrc: promise
    firebaseGetArr("regexes").then (list) ->
      matches = list.filter (regexObj) ->
        actualRegex = PersistentOverride.regexFromString(regexObj.regex)
        (sitename.constructor == String) && (sitename.match(actualRegex))
      matches.map (regexObj) ->
        sourceKey = regexObj.sourceKey
        actualRegex = PersistentOverride.regexFromString(regexObj.regex)
        scriptSrcPromise = firebaseGet("sourceCode/#{sourceKey}")
        { regex: actualRegex, scriptSrc: scriptSrcPromise }
        
  getScriptsForAllSites: () ->
    # returns list of hashes with signature:
    #   regex: regex as string
    #   scriptSrc: promise
    firebaseGetArr("regexes").then (objects) ->
      if Array.isArray(objects)
        results = objects.map (rejexObj) ->
          actualRegex = PersistentOverride.regexFromString(rejexObj.regex)
          sourceKey = rejexObj.sourceKey
          scriptSrcPromise = firebaseGet("sourceCode/#{sourceKey}")
          { regex: actualRegex, scriptSrc: scriptSrcPromise }
      else
        results
      
  setAutoRun: (savedObject, regex) ->

  getAutoRun: (regex) ->

  regexFromString: (string) ->
    # i.e. transforms "/asd/i" into /asd/i
    # credit: http://stackoverflow.com/a/39154413/2981429
    # it's also possible to simply use eval(string), but it's slower
    parts = /\/(.*)\/(.*)/.exec(string)
    new RegExp(parts[1], parts[2])

  # from http://stackoverflow.com/a/6969486/2981429
  escapeRegExp: (str) ->
    str.replace /[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&"
  
  # fix bugs with location.origin caused by browser extensions
  getCorrectLocationOrigin: () ->
    prevOrigins = location.ancestorOrigins
    if prevOrigins.length > 0
      prevOrigins[0]
    else
      location.origin
      
  # call a fn, passing it a regex for matching all sites
  forAllSites: (fn) ->
    fn /.+/
  
  # call a fn, passing it a regex for matching the current site
  forCurrentSite: (fn) ->
    currentPageRegexString = PersistentOverride.escapeRegExp(
      PersistentOverride.getCorrectLocationOrigin()
    )
    finalRegexString = "^" + currentPageRegexString + ".?"
    fn(new RegExp(finalRegexString))
    
  scriptRef: {}
  pageScripts: {}
  
  loadCurrentSiteScripts: () ->
    PO.getScriptsForCurrentSite().then (scripts) ->
      scripts.forEach (scriptObj) ->
        scriptObj.scriptSrc.then (srcString) ->
          eval("PO.scriptRef = #{srcString}")
          PO.copyScriptRefToPageScripts()
          
  
  copyScriptRefToPageScripts: () ->
    scriptRef = PO.scriptRef
    if (scriptRef) && (typeof(scriptRef) == 'object') && !(Array.isArray(scriptRef))
      Object.keys(scriptRef).forEach (key) ->
        PO.pageScripts[key] = scriptRef[key]

  init: () ->
    firebase.initializeApp(config)
    firebaseSignIn()
    PO.loadCurrentSiteScripts()
    
# alias
PO = PersistentOverride
