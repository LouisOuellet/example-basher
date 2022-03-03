#!/bin/bash
#==============================================================================
#TITLE:            example.sh
#DESCRIPTION:      This an example script using Basher
#AUTHOR:           Louis Ouellet
#DATE:             2022-03-03
#VERSION:          22.03-03

#==============================================================================
# SCRIPT SETUP
#==============================================================================

# Identify OS
unameOut="$(uname -s)"
case "${unameOut}" in
  Linux*)     OS=Linux;;
  Darwin*)    OS=Mac;;
  CYGWIN*)    OS=Windows;;
  MINGW*)     OS=MinGw;;
  *)          OS="UNKNOWN:${unameOut}"
esac

# Identify Script Directory
if [[ "$OS" != "Mac" ]]; then
  scriptDirectory=$(dirname $(readlink -f $0))
else
  scriptDirectory=$(dirname $(greadlink -f $0))
fi

# Script name
scriptName=$(echo $0 | sed -e 's@.*/@@')

# Script Personalisation
helpOptions="
-v                     => Enable Reporting Mode
                          Input commands sent are stored in ${logFile}
-e                     => Compile errors and warnings after execution
-s                     => Send report via email
-f                     => Disable all formatting
"
helpFunctions="
"

#==============================================================================
# INIT
#==============================================================================

# Source Basher
source ${scriptDirectory}/vendor/basher/basher

#==============================================================================
# FUNCTIONS
#==============================================================================



#==============================================================================
# RUN OPTIONS & FUNCTIONS
#==============================================================================

format
elements

while getopts ":vedsf" option; do
	case "${option}" in
		v)
			verboseMode=true
			;;
		d)
			debugMode=true
			;;
		s)
			debugSend=true
			;;
		e)
			debugError=true
			;;
		f)
			clrformat
			elements
			;;
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

echo "Hello World!"

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
