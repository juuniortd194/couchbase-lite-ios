Pod::Spec.new do |s|
  s.name                  = 'CouchbaseLite'
  s.version               = '2.0DB1'
  s.license               = 'Apache License, Version 2.0'
  s.homepage              = 'http://mobile.couchbase.com'
  s.summary               = 'An embedded syncable NoSQL database for iOS, tvOS, and MacOS apps.'
  s.author                = 'Couchbase'
  s.source                = { :git => 'https://github.com/couchbase/couchbase-lite-ios.git', :tag => '2.0DB1', :submodules => true }

  s.libraries             = "sqlite3", "c++"

  s.compiler_flags        = "-DSQLITE_OMIT_LOAD_EXTENSION", 
                            "-DSQLITE_ENABLE_FTS4", 
                            "-DSQLITE_ENABLE_FTS4_UNICODE61", 
                            "-D_CRYPTO_CC", 
                            "-D_DOC_COMP"
  
  s.public_header_files   = "Objective-C/*.h"
  
  s.prefix_header_file    = "Objective-C/Internal/CBLPrefix.h"

  s.source_files          = "Objective-C/*.{h,m,mm}",
                            "Objective-C/Internal/**/*.*",
                            "vendor/couchbase-lite-core/C/*.{h,hh,c,cc}",
                            "vendor/couchbase-lite-core/C/include/*.h",
                            "vendor/couchbase-lite-core/LiteCore/{BlobStore,Database,Indexes,Query,RevTrees,Storage,VersionVectors,Support}/*.{h,hh,cc,cpp}",
                            "vendor/couchbase-lite-core/vendor/fleece/Fleece/**/*.{hh,h,cc,mm}",
                            "vendor/couchbase-lite-core/vendor/fleece/ObjC/*.{h,mm}",
                            "vendor/couchbase-lite-core/vendor/fleece/vendor/{jsonsl,libb64}/*.{h,c}",
                            "vendor/couchbase-lite-core/vendor/sqlite3-unicodesn/**/*.{h,c}",
                            "vendor/couchbase-lite-core/vendor/SQLiteCpp/src/*.cpp", 
                            "vendor/couchbase-lite-core/vendor/SQLiteCpp/include/SQLiteCpp/*.h",
                            "vendor/MYUtilities/{CollectionUtils,MYErrorUtils,MYLogging,MYURLUtils,Test,Test_Assertions}.{h,m}"

  s.exclude_files         = "vendor/couchbase-lite-core/vendor/sqlite3-unicodesn/libstemmer_c/libstemmer/libstemmer.c"

  s.xcconfig              = {
    'HEADER_SEARCH_PATHS' => '$(inherited) "$(PODS_ROOT)/CouchbaseLite/vendor/couchbase-lite-core/vendor/SQLiteCpp/include" "$(PODS_ROOT)/CouchbaseLite/vendor/couchbase-lite-core/vendor/fleece/vendor/"'
    }

  s.ios.deployment_target  = '8.0'
  s.osx.deployment_target  = '10.10'
  s.tvos.deployment_target = '9.0'
end
