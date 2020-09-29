#!/usr/bin/env bash

loadVariables(){
    filename="$1"
    while read line
    do 
        delimiter=": "
        string=$line$delimiter

        myarray=()
        while [[ $string ]]; do
            myarray+=( "${string%%"$delimiter"*}" )
            string=${string#*"$delimiter"}
        done
        export "${myarray[0]}"="${myarray[1]}"
        
    done < $filename
}

callMakefile(){
    exporter_path="$1" 
    IFS="/" read tmp exporter_name exporter_yaml <<< "$exporter_path" 

    loadVariables $exporter_path
    current_pwd=$(pwd)
    cd  ./exporters/"$exporter_name" && make all 
    cd $current_pwd

    EXPORTER_HEAD = $(if $(EXPORTER_TAG),$(EXPORTER_TAG),$(EXPORTER_COMMIT))

    echo -n "export E_NAME=$exporter_name\nexport E_HEAD=$EXPORTER_HEAD\nexport E_VERSION=$VERSION\n" > var.tmp
}

old=$(git describe --tags --abbrev=0)
exporter=$(git --no-pager diff  --name-only $old "exporters/**/exporter.yml")

if [ -z "$exporter" ]
then
      exit 0
fi

if (( $(git --no-pager diff  --name-only $old "exporters/**/exporter.yml"| wc -l) > 1 ))
then
      echo "Only one definition should be modified at the same time"
      exit 1
fi


echo "Found a difference in $exporter, rebuilding packages"
callMakefile $exporter


