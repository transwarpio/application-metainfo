#!/usr/bin/env bash
execute(){
    SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
    WORKSPACE="${SCRIPT_DIR}/../.."
    version_x=${1:10:1}
    version_y=${1:12:1}
    version_z=${1:14:1}
    for i in `ls -l ${WORKSPACE}|grep ^d|awk '{print $9}'`
    do
        echo $i
        if [ $i == "DASHBOARD" ]
        then
            continue
        else
            c=1
            flag=0
            for j in `ls ${WORKSPACE}/${i}`
            do
                if [[ $j == ${1} ]]
                then
                    flag=1
                    echo "--${j}"
                fi

                if [ "${j: -5}" == "final" ]
                then

                    if [[ ${j:0-11:1} -lt $version_x ]]
                    then
                        finalList[c]=$j
                        c=`expr $c+1`


                    elif [[ ${j:0-11:1} == $version_x ]]
                    then
                        if [[ ${j:0-9:1} -lt $version_y ]]
                        then
                            finalList[c]=$j
                            c=`expr $c+1`


                        elif [[ ${j:0-9:1} == $version_y ]]
                        then
                            if [[ ${j:0-7:1} -lt ${version_z:=0} ]]
                            then
                                finalList[c]=$j
                                c=`expr $c+1`
                            fi
                        fi

                    fi
                fi

            done

            if [ $flag == 1 ]
            then
                g=1
                for k in `seq 1 ${#finalList[@]}`
                do
                    version=${finalList[k]}
                    version_n=${finalList[k+1]}
                    if [[ ${version:0-9:1} -ne ${version_n:0-9:1} ]] || [[ ${#version} -ne ${#version_n} ]]
                    then
                        result[g]=$version
                        g=`expr $g+1`
                    fi
                done

                for m in `seq 1 ${#result[@]}`
                do
                    for n in `seq ${m} ${#result[@]}`
                    do
                        for p in `ls ${WORKSPACE}/$i/${result[n]}`
                        do
                            if [ $p == "upgrade" ]
                            then
                                for o in `ls ${WORKSPACE}/$i/${result[n]}/upgrade`
                                do
                                   v=${o#*_}
                                   v=${v%.*}
                                   if [ ${v} == ${result[m]} ]
                                   then
                                       result[m]=0
                                       break 3
                                   fi
                                done
                            fi
                        done


                    done
                done
                tag_2=0
                for r in `ls ${WORKSPACE}/$i/${1}`
                do
                    if [ $r == "upgrade" ]
                    then
                        rm -rf ${WORKSPACE}/$i/${1}/upgrade/*
                        tag_2=1
                    fi
                done
                if [ $tag_2 == 1 ]
                then
                    for p in ${result[@]}
                    do
                        if [ $p != 0 ]
                        then
                            echo -e "---\nfromVersion: ${p}\nrolling: false" > ${WORKSPACE}/${i}/${1}/upgrade/from_${p}.yaml
                            echo "---------from_${p}.yaml"
                        fi
                    done
                fi
            fi
            unset finalList
            unset result
        fi


    done
}
parameter=$1
if [ "$#" != "1" ]; then
    echo "usage is createUpgrade <version>"
    exit 1
else
    case $parameter in
        -h|--help|"") echo "usage is createUpgrade <version>" ;;
        *) execute $parameter
    esac
fi
