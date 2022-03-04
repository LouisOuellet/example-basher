#!/bin/bash
#==============================================================================
#TITLE:            example.sh
#DESCRIPTION:      This an example script using Basher
#AUTHOR:           Louis Ouellet
#DATE:             2022-03-03
#VERSION:          22.03-03

#==============================================================================
# INIT
#==============================================================================

# Pull Basher
if [[ ! -f "${scriptDirectory}vendor/basher/basher" ]]; then
  git submodule update
fi

# Source Basher
source ${scriptDirectory}vendor/basher/basher

#==============================================================================
# SCRIPT PERSONALISATION
#==============================================================================

# Script Personalisation
helpOptions="${helpOptions}"

#==============================================================================
# FUNCTIONS
#==============================================================================

function hello(){
  echo "Hello World!"
}

#==============================================================================
# RUN OPTIONS & FUNCTIONS
#==============================================================================

parameters=
while getopts "${opts}" option; do
	case "${option}" in
    -)
      case "${OPTARG}" in
        *=*)
          val=${OPTARG#*=}
          opt=${OPTARG%=$val}
          lookup "-${opt}" ${val}
          ;;
        *)
          val="${!OPTIND}"
          OPTIND=$((OPTIND +1))
          lookup "-${OPTARG}" ${val}
          ;;
      esac
      ;;
    *)
      lookup "${option}" ${OPTARG}
      ;;
	esac
done
shift $((OPTIND -1))

#==============================================================================
# RUN SCRIPT
#==============================================================================

hello

if [[ "${verboseMode}" == "true" ]]; then
  duration=$SECONDS
  echo "#############################################################" | dbg i e
  echo "log file.......: ${logFile}" | dbg i v
  echo "$((${duration} / 60)) minutes and $((${duration} % 60)) seconds elapsed." | dbg i v
  echo "#############################################################" | dbg i e
  if [[ "${debugMode}" == "true" ]] && [[ "${debugSend}" == "true" ]]; then
    send -a ${logFile} "Debug Report" "See attached report."
  fi
fi

if [[ "${debugMode}" == "true" ]] && [[ "${debugError}" == "true" ]]; then
  if [[ -f "${logFile}" ]]; then
    case "${OS}" in
      Mac)cat ${logFile} | egrep '(✗|!)';;
      *)cat ${logFile} | egrep '✗|!';;
    esac;
  fi
fi

exit 0
