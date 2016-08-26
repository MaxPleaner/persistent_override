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
    cat src/firebase.js >> $Dest
    
    # Firebase Helpers
    cat tmp/start_firebase.js >> $Dest
    
    # Main script
    cat tmp/persistent_override.js >> $Dest

# Copy html page to dist for testing purposes

    rm dist/index.html
    cp test/index.html dist/index.html

