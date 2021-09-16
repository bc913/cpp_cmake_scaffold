#ifndef BCDYNAPI_H
#define BCDYNAPI_H

#ifdef _WIN32
#   ifndef BCDYN_API
#       ifdef DYNLIB_EXPORT
#           define BCDYN_API  __declspec( dllexport )
#       else
#           define BCDYN_API  __declspec( dllimport )
#       endif
#   endif
#else
#   ifndef BCDYN_API
#       define BCDYN_API __attribute__((visibility("default")))
#   endif
#endif

#endif //BCDYNAPI_H