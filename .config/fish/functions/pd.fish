# Defined in - @ line 1
function pd --description alias\ pd=python3\ -c\ \"import\ readline\;\ import\ rlcompleter\;\ readline.parse_and_bind\(\\\"tab:\ complete\\\"\)\;\ help\(\)\"
	python3 -c "import readline; import rlcompleter; readline.parse_and_bind(\"tab: complete\"); help()" $argv;
end
