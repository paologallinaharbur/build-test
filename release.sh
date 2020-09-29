#!/usr/bin/env bash

loadVariables(){

    export NAME=$(yq read $EXPORTER_PATH name)
    export VERSION=$(yq read $EXPORTER_PATH version)
    export EXPORTER_REPO_URL=$(yq read $EXPORTER_PATH exporter_repo_url)
    export EXPORTER_TAG=$(yq read $EXPORTER_PATH exporter_tag)
    export EXPORTER_COMMIT=$(yq read $EXPORTER_PATH exporter_commit)
    export EXPORTER_CHANGELOG=$(yq read $EXPORTER_PATH exporter_changelog)

    echo $EXPORTER_TAG
    if [[ -z $EXPORTER_TAG ]]
    then
        export EXPORTER_HEAD=$EXPORTER_COMMIT
    else
        export  EXPORTER_HEAD=$EXPORTER_TAG 
    fi
}

setStepOutput(){
    echo "::set-output name=NAME::${NAME}"
    echo "::set-output name=EXPORTER_HEAD::${EXPORTER_HEAD}"
    echo "::set-output name=EXPORTER_REPO_URL::${EXPORTER_REPO_URL}"
    echo "::set-output name=VERSION::${VERSION}"
    echo "::set-output name=EXPORTER_CHANGELOG::${EXPORTER_CHANGELOG}"
    echo "::set-output name=CREATE_RELEASE::${CREATE_RELEASE}"
    echo "::set-output name=EXPORTER_PATH::${EXPORTER_PATH}"
}

packageLinux(){
    IFS="/" read tmp exporter_name exporter_yaml <<< $EXPORTER_PATH 

    current_pwd=$(pwd)
    cd  ./exporters/"$exporter_name" && make all 
    cd $current_pwd
    CREATE_RELEASE=true
    EXPORTER_PACKAGE_SUCCEED=$EXPORTER_COMMIT
}

getExporterPath(){
    old=$(git describe --tags --abbrev=0)
    export EXPORTER_PATH=$(git --no-pager diff  --name-only $old "exporters/**/exporter.yml")
    CREATE_RELEASE=false

    if [ -z "$EXPORTER_PATH" ]
    then
        exit 0
    fi

    if (( $(git --no-pager diff  --name-only $old "exporters/**/exporter.yml"| wc -l) > 1 ))
    then
        echo "Only one definition should be modified at the same time"
        exit 1
    fi
}




