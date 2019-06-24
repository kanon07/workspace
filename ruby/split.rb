#prompt
#$bash#ruby split.rb ???.V2

aflag = 0
vflag = 0
dflag = 0
cnum = 0
trashcnt = 12

    open("ACCEL1","w") do |text1| #make file
    open("ACCEL2","w") do |text2| #output filename is ACCEL2
    open("ACCEL3","w") do |text3| #filename is text3 in code
    open("VELOC1","w") do |text4|
    open("VELOC2","w") do |text5|
    open("VELOC3","w") do |text6|
    open("DISPL1","w") do |text7|
    open("DISPL2","w") do |text8|
    open("DISPL3","w") do |text9|

    while line = gets
        if line.include?("POINTS OF ACCEL DATA EQUALLY SPACED AT") then
            aflag = 1 #ACCEL start
            cnum += 1 #channel number
        elsif line.include?("POINTS OF VELOC DATA EQUALLY SPACED AT") then
            aflag = 0 # ACCEL end
            vflag = 1 # VELOC start
        elsif line.include?("POINTS OF DISPL DATA EQUALLY SPACED AT") then
            vflag = 0 # VELOC end
            dflag = 1 # DISPL start
        elsif line.include?("END OF DATA") then
           dflag = 0
        end

        if aflag == 1 then
            if line.include?("POINTS OF ACCEL DATA EQUALLY SPACED AT") then #erase "4000 POINTS OF ..."
                next
            end
            line.chomp!
            line.split.each{|x| #split words to word
            case cnum # channel number switch
            when 1 then
                text1.puts(x)
            when 2 then
                text2.puts(x)
            when 3 then
                text3.puts(x)
            end
            }
        elsif vflag == 1 then
            if line.include?("POINTS OF VELOC DATA EQUALLY SPACED AT") then
                next
            end
            line.chomp!
            line.split.each{|x|
            case cnum
            when 1 then
                text4.puts(x)
            when 2 then
                text5.puts(x)
            when 3 then
                text6.puts(x)
            end

            }
        elsif dflag == 1 then
            if line.include?("POINTS OF DISPL DATA EQUALLY SPACED AT") then
                next
            end
            line.chomp!
            line.split.each{|x|
            case cnum
            when 1 then
                text7.puts(x)
            when 2 then
                text8.puts(x)
            when 3 then
                text9.puts(x)
            end

            }
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

