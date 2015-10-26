#!/bin/bash

echo '##############################################'
echo '#   Running setup for new virtual machine    #'
echo '##############################################'
echo 
echo This window will close when complete
echo

source "$HOME/.rvm/scripts/rvm"

rvms=`rvm list strings`
for rvm in $rvms
do
  rvm use $rvm
  for dir in `ls ~/git`
  do
    cd ~/git/$dir
    bundle install
  done
done

cd ~/git
git config --global user.name "Jeremy Rotter"
git config --global user.email "jrotter@carekinesis.com"

rm -f -- "$0"
rm -f /home/jrotter/.onetime

