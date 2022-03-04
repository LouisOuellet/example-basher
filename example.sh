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

while getopts ":" option; do
	case "${option}" in
    \? )
      echo "Invalid option: $OPTARG" 1>&2
      help
      exit 0
      ;;
    : )
      echo "Invalid option: $OPTARG requires an argument" 1>&2
      help
      exit 0
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
