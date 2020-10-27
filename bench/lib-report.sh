#!/usr/bin/env bash
# shellcheck disable=1091,2016

tag_format_timetoblock_header="tx id,tx time,block time,block no,delta t"
patch_run() {
        local dir=${1:-.}
        dir=$(realpath "$dir")

        if test "$(head -n1 "$dir"/analysis/timetoblock.csv)" \
                != "${tag_format_timetoblock_header}"
        then echo "---| patching $dir/analysis/timetoblock.csv"
             sed -i "1 s_^_${tag_format_timetoblock_header}\n_; s_;_,_g" \
                 "$dir"/analysis/timetoblock.csv
        fi
}

package_run() {
        local tag report_name package
        dir=${1:-.}
        tag=$(run_tag "$dir")
        report_name=$(run_report_name "$dir")

        if is_run_broken "$dir"
        then resultroot=$(realpath ../bench-results-bad)
        else resultroot=$(realpath ../bench-results); fi

        package=${resultroot}/$report_name.tar.xz

        oprint "Packaging $tag as:  $package"
        ln -sf "./runs/$tag" "$report_name"
        tar cf "$package"    "$report_name" --xz --dereference
        rm -f                "$report_name"
}
