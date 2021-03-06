find_package(Git)

if(GIT_EXECUTABLE)
  # Generate a git-describe version string from Git repository tags
  execute_process(
    COMMAND ${GIT_EXECUTABLE} describe --tags --dirty --match "v*"
    WORKING_DIRECTORY .
    OUTPUT_VARIABLE GIT_DESCRIBE_VERSION
    RESULT_VARIABLE GIT_DESCRIBE_ERROR_CODE
    OUTPUT_STRIP_TRAILING_WHITESPACE
    )
  if(NOT GIT_DESCRIBE_ERROR_CODE)
    set(CURRENT_TAG ${GIT_DESCRIBE_VERSION})
  endif()
endif()

# Final fallback: Just use a bogus version string that is semantically older
# than anything else and spit out a warning to the developer.
if(NOT DEFINED CURRENT_TAG)
  set(CURRENT_TAG 0.0.0)
  message(WARNING "Failed to determine FOOBAR_VERSION from Git tags. Using default version \"${CURRENT_TAG}\".")
endif()

string(REGEX MATCH "[^v-]+[\\.][0-9]+[\\.][0-9]+" CURRENT_VERSION ${CURRENT_TAG})
string(FIND ${CURRENT_VERSION} "." DOT_ONE_POS)
string(FIND ${CURRENT_VERSION} "." DOT_TWO_POS REVERSE)
string(LENGTH ${CURRENT_VERSION} CURRENT_VERSION_LENGTH)

MATH(EXPR CURRENT_MINOR_INDEX "${DOT_ONE_POS} + 1")
MATH(EXPR CURRENT_MINOR_LENGHT "${DOT_TWO_POS} - ${CURRENT_MINOR_INDEX}")
MATH(EXPR CURRENT_PATCH_INDEX "${DOT_TWO_POS} + 1")
MATH(EXPR CURRENT_PATCH_LENGTH "${CURRENT_VERSION_LENGTH} - ${CURRENT_PATCH_INDEX}")

string(SUBSTRING ${CURRENT_VERSION} 0 ${DOT_ONE_POS} CURRENT_MAJOR_VERSION)
string(SUBSTRING ${CURRENT_VERSION} ${CURRENT_MINOR_INDEX} ${CURRENT_MINOR_LENGHT}  CURRENT_MINOR_VERSION)
string(SUBSTRING ${CURRENT_VERSION} ${CURRENT_PATCH_INDEX} ${CURRENT_PATCH_LENGTH}  CURRENT_PATCH_VERSION)

message("::set-output name=current_version_tag::${CURRENT_TAG}")