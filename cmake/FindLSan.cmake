# The MIT License (MIT)
#
# Copyright (c)
#   2025 Chris Samuelson
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

option(SANITIZE_LEAK "Enable LeakSanitizer for sanitized targets." Off)

set(FLAG_CANDIDATES
  # MSVC uses
  "/fsanitize=leak"

  # clang/gcc uses
  "-g -fsanitize=leak"
)

# I didn't find documentation of incompatibilities of leak sanitizer with others
# I somehow doubt that's true
#if (SANITIZE_ADDRESS AND (SANITIZE_THREAD OR SANITIZE_MEMORY))
#    message(FATAL_ERROR "AddressSanitizer is not compatible with "
#        "ThreadSanitizer or MemorySanitizer.")
#endif ()

include(sanitize-helpers)

if (SANITIZE_LEAK)
  if (NOT ${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
    message(WARNING "LeakSanitizer disabled for target ${TARGET} because "
      "LeakSanitizer is supported for Linux systems only.")
    set(SANITIZE_LEAK Off CACHE BOOL
      "Enable LeakSanitizer for sanitized targets." FORCE)
  elseif (NOT ${CMAKE_SIZEOF_VOID_P} EQUAL 8)
    message(WARNING "LeakSanitizer disabled for target ${TARGET} because "
      "LeakSanitizer is supported for 64bit systems only.")
    set(SANITIZE_LEAK Off CACHE BOOL
      "Enable LeakSanitizer for sanitized targets." FORCE)
  else ()
    sanitizer_check_compiler_flags("${FLAG_CANDIDATES}" "LeakSanitizer"
      "LSan")
  endif ()
endif ()

function (add_sanitize_leak TARGET)
  if (NOT SANITIZE_LEAK)
    return()
  endif ()

  sanitizer_add_flags(${TARGET} "LeakSanitizer" "LSan")
endfunction ()

