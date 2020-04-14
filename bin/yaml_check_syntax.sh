#!/usr/bin/env bash
repo_dir="$(dirname $0)/.."
. "${repo_dir}/bin/functions"
PATH=/opt/puppetlabs/puppet/bin:$PATH
PUPPET=$(which puppet)
ERB=$(which erb)
RUBY=$(which ruby)
R10K=$(which r10k)
BASH=$(which bash)
global_exit=0
filter=' grep -v .js '
check=${1:-all}

check_chars () {
  if [ -n ${PUPPET} ]; then
    echo_title "Checking for pesky non printable characters in files."
  
    grep -I -H -P -n "[\xa0]" --color=yes -r * | $filter |tr '\302\102' 'X'
  fi
}
  
check_yaml () {
  if [ ! -z ${RUBY} ]; then
    echo_title "Validating YAML files"
    for i in $(find . -name "*.yaml")
    do
      echo -ne "$i - "
      err=$(${RUBY} -e "require 'yaml'; YAML.parse(File.open('$i'))" 2>&1)
      if [ $? = 0 ]; then
        echo_success "OK"
      else
        echo_failure "ERROR"
        echo $err
        global_exit=1
      fi
    done
  else
    echo_warning "ruby not found."
  fi

}

case $check in
  chars) check_chars ;;
  yaml) check_yaml ;;
  all)
   check_chars
   check_yaml
   ;;
esac 
  
exit $global_exit
