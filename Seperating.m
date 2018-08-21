function [row, col] = Seperating(SensN_Selected)

if SensN_Selected <= 1
    row = 2; col = 1;    
else
    if SensN_Selected <= 2
        row = 2; col = 2;   
    else
        if SensN_Selected <= 3
            row = 2; col = 3;   
        else
            if SensN_Selected <= 4
                row = 4; col = 2;   
            else
                if SensN_Selected <= 6
                    row = 4; col = 3;   
                else
                    if SensN_Selected <= 8
                        row = 4; col = 4;   
                    else
                        if SensN_Selected <= 9
                            row = 6; col = 3;   
                        else
                            if SensN_Selected <= 10
                                row = 4; col = 5;   
                            else
                                if SensN_Selected <= 12
                                    row = 6; col = 4;   
                                else
                                    if SensN_Selected <= 15
                                        row = 6; col = 5;   
                                    else
                                        if SensN_Selected <= 16
                                            row = 8; col = 4;   
                                        else
                                            if SensN_Selected <= 18
                                                row = 6; col = 6;   
                                            else
                                                if SensN_Selected <= 20
                                                    row = 8; col = 5;   
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
end