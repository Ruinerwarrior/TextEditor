find_package(Git)

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

if(${BUMB_VERSION} STREQUAL "MAJOR")
  MATH(EXPR NEW_MAJOR_VERSION "${CURRENT_MAJOR_VERSION} + 1")
  SET(NEW_MINOR_VERSION 0)
  SET(NEW_PATCH_VERSION 0)
elseif(${BUMB_VERSION} STREQUAL "MINOR")
  SET(NEW_MAJOR_VERSION ${CURRENT_MAJOR_VERSION})
  MATH(EXPR NEW_MINOR_VERSION "${CURRENT_MINOR_VERSION} + 1")
  SET(NEW_PATCH_VERSION 0)
elseif(${BUMB_VERSION} STREQUAL "PATCH")
  SET(NEW_MAJOR_VERSION ${CURRENT_MAJOR_VERSION})
  SET(NEW_MINOR_VERSION ${CURRENT_MINOR_VERSION})
  MATH(EXPR NEW_PATCH_VERSION "${CURRENT_PATCH_VERSION} + 1")
endif()

SET(NEW_VERSION "${NEW_MAJOR_VERSION}.${NEW_MINOR_VERSION}.${NEW_PATCH_VERSION}")
SET(NEW_TAG "v${NEW_VERSION}")

message(STATUS "Bumping version from ${CURRENT_TAG} to ${NEW_TAG}")

if(GIT_EXECUTABLE)
  # update git tag
  execute_process(
    COMMAND ${GIT_EXECUTABLE} tag ${NEW_TAG}
    WORKING_DIRECTORY .
    RESULT_VARIABLE GIT_DESCRIBE_ERROR_CODE
    )
  if(GIT_DESCRIBE_ERROR_CODE)
    message(FATAL_ERROR "Unable to bumb version to ${NEW_TAG}")
  else()
    message(STATUS "git tag bumbed to ${NEW_TAG}")
  endif()

  # update git tag
  execute_process(
    COMMAND ${GIT_EXECUTABLE} push origin ${NEW_TAG}
    WORKING_DIRECTORY .
    RESULT_VARIABLE GIT_DESCRIBE_ERROR_CODE
    )
  if(GIT_DESCRIBE_ERROR_CODE)
    message(FATAL_ERROR "Unable to push version")
    else()
    message(STATUS "git tag pushed to origin")
  endif()
endif()

message("::set-output name=new_tag::${NEW_TAG}")
message("::set-output name=new_version::${NEW_VERSION}")
message("::set-output name=new_version_major::${NEW_MAJOR_VERSION}")
message("::set-output name=new_version_minor::${NEW_MINOR_VERSION}")
message("::set-output name=new_version_patch::${NEW_PATCH_VERSION}")
