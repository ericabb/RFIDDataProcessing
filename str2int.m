function value = str2int(str)
    switch length(str)
        case 1
            value = str-'0';
        case 2
            value = (str(1)-'0')*10+str(2)-'0';
    end
end