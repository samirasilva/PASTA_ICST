#!/bin/bash

#INSTRUCTIONS:
#Replace the file "DIRECTORY/OF/BSN/src/sa-bsn/environment/patient/src/PatientModule.cpp" with the content of the file "Baseline_PatientModule.cpp". 
#Note: Replace only the content and keep the name.
#In the folder /bsn/src/sa-bsn/configurations/environment/"

#Example of call: 
#bash script_random_dns.sh 'Path_to_Patients_folder' 'number_of_patients' 'execution_time' 'number_of_executions'
#or
#bash script_random_dns.sh


if [[ "$#" -gt 4 ]]; then
    echo "Too many arguments were passed!"
    exit 1
fi

if [[ "$#" -eq 0 ]]; then
    original_patient_folder="./patient"
    number_of_patients=1
    execution_time=8340
    number_of_executions=10
else
    original_patient_folder=$1
    number_of_patients=$2
    execution_time=$3
    number_of_executions=$4
fi

directory_ros="${HOME}/.ros/"
bsn_patient_folder="${HOME}/bsn/src/sa-bsn/configurations/environment/"

for ((j=0;j<"$number_of_executions";j++));do
   #Create the output folder
   directory_Output="./output_${j}/"
   if [ ! -d "$directory_Output" ]; then
       mkdir -p "$directory_Output"
   fi

   #Copy the patients to the BSN folder
   if [ -z "$(ls -A ${bsn_patient_folder})" ]; then
      echo "Empty"
   else
      rm "${bsn_patient_folder}"*".launch"
   fi
   cp -a "${original_patient_folder}/." "${bsn_patient_folder}"

   #Execute each patient and copy the resulting log file to the output folder
   origin=$(pwd)
   for ((i=0;i<"$number_of_patients";i++));do
      cd "${HOME}/bsn"
      source devel/setup.bash
      bash run.sh $execution_time $i
      cd "$origin"
      destiny="${directory_Output}g4t1_${i}-1-stdout.log"
      cp "${directory_ros}log/latest/g4t1-1-stdout.log" "$destiny"
   done
done
