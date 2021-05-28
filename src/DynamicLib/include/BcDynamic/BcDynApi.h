#ifndef BCDYNAPI_H
#define BCDYNAPI_H

#ifdef _WIN32
# ifdef DYNLIB_EXPORT
#   define BCDYN_API  __declspec( dllexport )
# else
#   define BCDYN_API  __declspec( dllimport )
# endif
#else
#   define BCDYN_API
#endif

#endif