#pragma once

#include <vector>
#include <string>


#ifdef _WIN32
  #define BCAN_EXPORT __declspec(dllexport)
#else
  #define BCAN_EXPORT
#endif

BCAN_EXPORT void bcan();
BCAN_EXPORT void bcan_print_vector(const std::vector<std::string> &strings);
