#!/bin/bash

echo "Hello, what is your favorite pie?"
read piechoice
echo "Ew"
echo "Generating public/private rsa key pair."
echo "Enter file in which to save the key (/home/username/.ssh/id_rsa):"
read filename
echo $filename
filepath="/home/admin/testing/$filename"
touch $filepath
echo "Come on, $piechoice really!?" > $filepath
echo "$filepath" created