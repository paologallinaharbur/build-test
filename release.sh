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

    if [[ -z $EXPORTER_TAG ]]
    then
        EXPORTER_HEAD=$EXPORTER_COMMIT
    else
        EXPORTER_HEAD=$EXPORTER_TAG
    fi
}

callMakefile(){
    exporter_path="$1" 
    IFS="/" read tmp exporter_name exporter_yaml <<< "$exporter_path" 

    loadVariables $exporter_path
    current_pwd=$(pwd)
    cd  ./exporters/"$exporter_name" && make all 
    cd $current_pwd
    CREATE_RELEASE=true
    EXPORTER_PACKAGE_SUCCEED=$EXPORTER_COMMIT
}

checkChanges(){
    old=$(git describe --tags --abbrev=0)
    exporter=$(git --no-pager diff  --name-only $old "exporters/**/exporter.yml")
    CREATE_RELEASE=false

    if [ -z "$exporter" ]
    then
        exit 0
    fi

    if (( $(git --no-pager diff  --name-only $old "exporters/**/exporter.yml"| wc -l) > 1 ))
    then
        echo "Only one definition should be modified at the same time"
        exit 1
    fi
}




