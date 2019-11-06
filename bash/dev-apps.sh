# Find list of all applications formatted by name in lowercase
    system_profiler -xml SPApplicationsDataType | awk '/<key>_name<\/key>/{getline; print}' | grep -v "<dict>" | sed -e 's/\<string\>\(.*\)\<\/string\>/\1/' | awk '{print tolower($0)}' | awk '{$1=$1;print}' | sed 's/[0-9]$//g' | sed 's/\-$//g' | sed 's/[[:space:]]$//g'
# OR
    system_profiler SPApplicationsDataType | awk '++n == 1; !NF {n = 0}' | grep -Ev "^[[:space:]]*Version:.*" | grep -Ev "^[[:space:]]*Obtained from:.*" | cut -d '=' -f2 | sed 's/.$//' | awk '{print tolower($0)}' | awk '{$1=$1;print}' | sed 's/[0-9]$//g' | sed 's/\-$//g' | sed 's/[[:space:]]$//g'





# Prints Obtained From
    system_profiler -xml SPApplicationsDataType | grep -A6 '<key>signed_by<\/key>' | grep -v "<key>signed_by<\/key>" | grep -v "<dict>" | grep -v "<key>_order</key>" | grep -v "</dict>" | grep -v "<key>version</key>" | grep -v "</array>" | grep -v "60" | grep -v "<array>" | sed -e 's/\<string\>\(.*\)\<\/string\>/\1/' | awk '{$1=$1;print}'
# OR
    system_profiler SPApplicationsDataType | grep -E '^[[:space:]]*Obtained from:.*' | awk '{$1=$1;print}' | sed '/^$/d' | cut -c16- | awk '{print tolower($0)}'









# Find list of all casks installed formatted by spaces rather than hyphens
brew cask list | awk '{$1=$1;print}' | tr "-" " " | sed 's/[0-9]$//g' | tr -d '\r' > ~/Desktop/casks.txt

# Find the Applications downloaded on the mac App Store, formatted by name
mas list | awk '{print tolower($0)}' | sed 's/[^a-z ]//g' | awk '{$1=$1;print}' > ~/Desktop/mas-apps.txt


# Find the Applications which are not casks bir
awk 'NR == FNR { list[tolower($0)]=1; next } { if (! list[tolower($0)]) print }' casks.txt applications-sp.txt > ~/Desktop/not-cask-apps.txt



# Not built-in
awk 'NR == FNR { list[tolower($0)]=1; next } { if (! list[tolower($0)]) print }' builtin-applications.txt not-cask-apps.txt  > ~/Desktop/not-cask-apps.txt



for i in $(system_profiler -xml SPApplicationsDataType | awk '/<key>path<\/key>/{getline; print}' | grep -v "<dict>" | sed -e 's/\<string\>\(.*\)\<\/string\>/\1/' | awk '{$1=$1;print}')
do
    j=$(basename $i)
    plutil -convert xml1 -o - $i/Contents/Info.plist >> $j.txt
done



for i in $(fd -e .app . /)
do
    j=$(basename $i)
    plutil -convert xml1 -o - $i/Contents/Info.plist >> $j.txt
done

 
 
 
 



# Make files for each application
for i in $(system_profiler SPApplicationsDataType | awk '++n == 1; !NF {n = 0}' | grep -v "Version:" | cut -d '=' -f2 | sed 's/.$//' | awk '{print tolower($0)}' | awk '{$1=$1;print}' | sed 's/[0-9]$//g' | sed 's/\-$//g' | sed 's/[[:space:]]$//g' | tr " " "-")
do 
    touch apps/"${i}"
done