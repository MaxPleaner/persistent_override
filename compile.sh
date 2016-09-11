#!/usr/bin/bash

# Compilation

    rm tmp/*
    PATH=$(npm bin):$PATH coffee -b -o tmp/ -c src/

# Delete/Create destination file

    Dest=dist/persistent_override.pkgd.js
    rm $Dest
    touch $Dest

# Concatenate indiviual files

    # Curry
    cat src/curry.min.js >> $Dest
    
    # toSource polyfill
    cat src/toSource.min.js >> $Dest
    
    # Firebase
    cat src/firebase.min.js >> $Dest
    
    # Firebase crednentials
    cat tmp//credentials.js >> $Dest
    
    # Firebase Helpers
    cat tmp/start_firebase.js >> $Dest
    
    # Main script
    cat tmp/persistent_override.js >> $Dest

# Copy html page to dist for testing purposes

    rm dist/index.html
    cp test/index.html dist/index.html

# Chrome extension

    rm chrome_extension/persistent_override.pkgd.js
    cp $Dest chrome_extension/
    
    CeDest=chrome_extension/content_script.pkgd.js
    rm $CeDest
    touch $CeDest
    cat chrome_extension/persistent_override.pkgd.js >> $CeDest
    cat chrome_extension/content_script.js >> $CeDest