function search_word
find $argv[1] -name $argv[2] | xargs grep $argv[3]
end
