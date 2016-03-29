require 'tk'

class Main
    
    LEFT = {:side=>'left',:padx=>2}
    TOP = {:side=>'top',:padx=>2}
    def initialize
        
        def frame(root)
            f = TkFrame.new(root)
            f.pack(:padx=>5,:pady=>2,:side=>'top')
            return f
        end
        
        root = TkRoot.new{title "simple ruby"}
        
        
        infr = frame(root)
        TkLabel.new(infr){
            text "Input:"
            width 8
            height 1
            pack LEFT
        }
        var_in = TkVariable.new
        TkEntry.new(infr) do
            textvariable var_in
            width 3
            pack LEFT
        end
        
        TkLabel.new(infr){
            text "Output:"
            width 8
            height 1
            pack LEFT
        }
        var_out = TkVariable.new
        TkEntry.new(infr) do
            textvariable var_out
            width 3
            pack LEFT
        end
        
        TkLabel.new(infr){
            text "Case:"
            width 8
            height 1
            pack LEFT
        }
        var_cas = TkVariable.new
        TkEntry.new(infr) do
            textvariable var_cas
            width 3
            pack LEFT
        end
        
        TkLabel.new(infr){
            text "Error:"
            width 8
            height 1
            pack LEFT
        }
        var_err = TkVariable.new
        TkEntry.new(infr) do
            textvariable var_err
            width 4
            pack LEFT
        end
        
        TkLabel.new(infr){
            text "Learn:"
            width 8
            height 1
            pack LEFT
        }
        var_ler = TkVariable.new
        TkEntry.new(infr) do
            textvariable var_ler
            width 4
            pack LEFT
        end
        
        TkLabel.new(infr){
            text "Layer:"
            width 8
            height 1
            pack LEFT
        }
        var_lay = TkVariable.new
        TkEntry.new(infr) do
            textvariable var_lay
            width 3
            pack LEFT
        end
        
        var_in.value =""
        var_out.value =""
        var_err.value =""
        var_ler.value =""
        var_lay.value =""
        
        TkButton.new(infr){
            text "Next"
            width 5
            
            command proc{
                input = var_in.value.to_i
                output = var_out.value.to_i
                caseset = var_cas.value.to_i
                error = var_err.value.to_f
                learn = var_ler.value.to_f
                layer = var_lay.value.to_i
                
                if input == 0 || output == 0 || caseset == 0 || error == 0 || learn == 0 || layer == 0
                Tk::messageBox :message => "有空欄位"
                elsif error > 0.5 || error < 0 || learn > 1 || learn <= 0 || layer < 3
                Tk::messageBox :message => "有欄位值輸入不正確\n 0 < Error <= 0.5 , 0 < Learn <= 1 , Layer > 2"
                else
                Nextset.functioninput(input,output,caseset,error,layer,learn)
                end
                
            }
            
            pack TOP
        }
        
    end
end

class Nextset
    
    LEFT = {:side=>'left',:padx=>2}
    TOP = {:side=>'top',:padx=>2}
    
    def self.functioninput(a,b,c,d,e,f)
    @ninput = a
    @noutput = b
    @ncaseset = c
    @nerror = d
    @nlayer = e
    @nlearn = f
    puts "input#{@ninput},#{@noutput},#{@ncaseset},#{@nerror},#{@nlearn},#{@nlayer}"
    
    Nextset.setfram
    
end


def self.frame(root)
f = TkFrame.new(root)
f.pack(:padx=>5,:pady=>2,:side=>'top')
return f
end


def self.setfram

root = TkRoot.new{title "BP ruby"}

inputnum = Array.new(@ncaseset){Array.new(@ninput)}         #儲存input
outputnum = Array.new(@ncaseset){Array.new(@noutput)}       #儲存output


1.upto(@ncaseset) do |n|
    
    infr = Nextset.frame(root)
    
    TkLabel.new(infr){
        text "Case #{n} :"
        width 8
        height 1
        pack LEFT
    }
    
    1.upto(@ninput) do |x|
        
        TkLabel.new(infr){
            text "Input #{x} :"
            width 8
            height 1
            pack LEFT
        }
        inputnum[n-1][x-1] = TkVariable.new
        TkEntry.new(infr) do
            textvariable inputnum[n-1][x-1]
            width 3
            pack LEFT
        end
    end
    
    1.upto(@noutput) do |x|
        
        TkLabel.new(infr){
            text "Output #{x} :"
            width 8
            height 1
            pack LEFT
        }
        outputnum[n-1][x-1] = TkVariable.new
        TkEntry.new(infr) do
            textvariable outputnum[n-1][x-1]
            width 3
            pack LEFT
        end
    end
end

f = frame(root)
TkButton.new(f){
    text "Start"
    width 8
    command proc{
        a = inputnum
        b = outputnum
        
        check = Nextset.checkin(a,b)
        
        if check == 1
        Tk::messageBox :message => "有錯誤輸入\n Input=1,0 Output=1,0"
        elsif check == 2
        Tk::messageBox :message => "有錯誤輸入\n Input重複"
        elsif check == 0
        Nextset.startrun(a,b)
        end
    }
    pack LEFT
}

@timeText = TkLabel.new(f) {
    text "Time"
    width 20
    height 1
    pack LEFT
}

TkButton.new(f){
    text "Delete"
    width 8
    command proc{
        
        Tk::messageBox :message => "維修中..."
        
#        this.class.close
    }
    pack LEFT
}

end


def self.checkin(a,b)

check = 0

0.upto(@ncaseset-1) do |n|
    0.upto(@noutput-1) do |x|
        if b[n][x] != 0 && b[n][x] != 1
            check = 1
            break
        end
    end
end
0.upto(@ncaseset-1) do |n|
    0.upto(@ninput-1) do |x|
        if a[n][x] != 0 && a[n][x] != 1
            check = 1
            break
        end
    end
end

0.upto(@ncaseset-1) do |n|
    0.upto(@ncaseset-1) do |m|
        
        same = 0
        
        if n != m
            0.upto(@ninput-1) do |x|
                if a[n][x]==a[m][x]
                    same = same + 1
                end
            end
        end
        
        if same == @ninput
            check = 2
            break
        end
    end
end

return check.to_i

end



def self.startrun(inarray,outarray)     #Start按鈕執行

puts "maxcase : #{@ncaseset} maxinput : #{@ninput} maxoutput : #{@noutput}"

w = Array.new(@nlayer)          #layer Array     [第layer層][上層][下層]
s = Array.new(@ncaseset){Array.new(@noutput)}#由inarray Array [case][ninput] 算出的 output
t = Array.new(@nlayer)          #每個node的 誤差值 output層公式不同 [layer != 0][node數]
node = Array.new(@ncaseset){Array.new(@nlayer-1){Array.new(3)}}       #暫存每個node的值 [layer][下層]

serror = true

1.upto(@nlayer) do |n|
    
    if n == 1
        w[n-1] = Array.new(@ninput){Array.new(3)}
        t[n-1] = Array.new(3)
        elsif n == @nlayer
        w[n-1] = Array.new(3){Array.new(@noutput)}
        t[n-1] = Array.new(@noutput)
        else
        w[n-1] = Array.new(3){Array.new(3)}
        t[n-1] = Array.new(3)
    end
end


randerr = -1.0 * ( Math.log10(@nerror) + 1.0 )
randnum = Math.log(@nlayer) * 1000


0.upto(@nlayer-1) do |n|
    if n == 0
        
        0.upto(@ninput-1) do |x|
            0.upto(2) do |y|
                r = Random.rand(2)
                if r == 1
                    w[n][x][y] = Random.rand(randnum.to_i)/1000.0 + randerr
                    else
                    w[n][x][y] = -1.0 * (Random.rand(randnum.to_i)/1000.0 + randerr)
                end
            end
        end
        
        elsif n == @nlayer
        
        0.upto(2) do |x|
            0.upto(@noutput-1) do |y|
                r = Random.rand(2)
                if r == 1
                    w[n][x][y] = Random.rand(randnum.to_i)/1000.0 + randerr
                    else
                    w[n][x][y] = -1.0 * (Random.rand(randnum.to_i)/1000.0 + randerr)
                end
            end
        end
        
        else
        
        0.upto(2) do |x|
            0.upto(2) do |y|
                r = Random.rand(2)
                if r == 1
                    w[n][x][y] = Random.rand(randnum.to_i)/1000.0 + randerr
                    else
                    w[n][x][y] = -1.0 * (Random.rand(randnum.to_i)/1000.0 + randerr)
                end
            end
        end
        
    end
end


puts "#{@ncaseset} #{@nlayer} #{@ninput}"




time = 0

while(serror)
    
    @timeText.text = "Time : #{time}"
    
    time += 1
    
    #計算每個case的output值
    0.upto(@ncaseset-1) do |n|
        
        #計算每個node值
        0.upto(@nlayer-1) do |y|        #layer
            
            if y == 0               #input層
                0.upto(2) do |i|        #下層
                    0.upto(@ninput-1) do |x|    #上層
                        
                        aaa = w[y][x][i]
                        bbb = node[n][y][i]
                        node[n][y][i] = bbb.to_f + inarray[n][x]*aaa.to_f
                        
                        
                    end
                    bbb = node[n][y][i]
                    node[n][y][i] = Nextset.functionchange(bbb.to_f)
                end
                elsif y == @nlayer-1    #output層
                0.upto(@noutput-1) do |i|
                    0.upto(2) do |x|
                        
                        aaa = w[y][x][i]
                        bbb = s[n][i]
                        ccc = node[n][y-1][x]
                        s[n][i] = bbb.to_f + ccc.to_f*aaa.to_f
                        
                    end
                    #計算出的output
                    bbb = s[n][i]
                    s[n][i] = Nextset.functionchange(bbb.to_f)
                    cccc = s[n][i]
                    puts "Case#{n} Output#{i} = #{cccc}"
                end
                else                    #隱藏層
                0.upto(2) do |i|
                    0.upto(2) do |x|
                        
                        aaa = w[y][x][i]
                        bbb = node[n][y][i]
                        ccc = node[n][y-1][x]
                        node[n][y][i] = bbb.to_f + ccc.to_f*aaa.to_f
                        
                    end
                    #隱藏層的node值
                    bbb = node[n][y][i]
                    node[n][y][i] = Nextset.functionchange(bbb.to_f)
                end
            end
        end
    end #end case
    
    
    
    serror = false
    0.upto(@ncaseset-1) do |n|
        0.upto(@noutput-1) do |i|
            x = outarray[n][i]
            y = s[n][i]
            if((x.to_f - y.to_f).abs > @nerror)
                serror = true
                break
            end
        end
    end
    
    if serror == false
        break
    end
    
    range = (0 .. @ncaseset-1).to_a
    
    q = range.sample(@ncaseset)
    
    if  serror == true
        0.upto(@ncaseset-1) do |abcde|
            
            
            n = q[abcde]
            
            #從最上層開始變動
            (@nlayer-1).downto(0) do |y|
                
                if y == @nlayer-1
                    
                    0.upto(@noutput-1) do |i|   #本層
                        
                        #計算t值
                        aaa = outarray[n][i]
                        bbb = s[n][i]
                        t[y][i] = (aaa.to_f - bbb.to_f) * bbb.to_f * (1.0 - bbb.to_f)
                        ccc = t[y][i]
                        
                        0.upto(2) do |x|    #上層
                            
                            #新權重值
                            asr = w[y][x][i]
                            ddd = node[n][y-1][x]  #上層node
                            w[y][x][i] = asr.to_f + (@nlearn * ddd.to_f * ccc.to_f)
                            
                        end
                    end
                    
                    elsif y == @nlayer-2
                    
                    0.upto(2) do |i|    #本層
                        
                        #計算wt和
                        sum = 0.0
                        
                        #計算下層wt和
                        0.upto(@noutput-1) do |x|   #下層
                            
                            aaa = t[y+1][x]
                            bbb = w[y+1][i][x]
                            sum = sum.to_f + (aaa.to_f * bbb.to_f)
                            
                        end
                        
                        ccc = node[n][y][i]  #本層node
                        t[y][i] = sum.to_f * ccc.to_f * (1.0 - ccc.to_f)
                        ddd = t[y][i]
                        
                        0.upto(2) do |x|    #上層
                            
                            asr = w[y][x][i]
                            eee = node[n][y-1][x]  #上層node
                            w[y][x][i] = asr.to_f + (@nlearn * ddd.to_f * eee.to_f)
                            
                        end
                    end
                    
                    elsif y == 0
                    
                    0.upto(2) do |i| # 本層
                        
                        #計算wt和
                        sum = 0.0
                        
                        0.upto(2) do |x|    #下層
                            
                            aaa = t[y+1][x]
                            bbb = w[y+1][i][x]
                            sum = sum.to_f + (aaa.to_f * bbb.to_f)
                            
                        end
                        
                        ccc = node[n][y][i]  #本層node
                        t[y][i] = sum.to_f * ccc.to_f * (1.0 - ccc.to_f)
                        ddd = t[y][i]
                        
                        0.upto(@ninput-1) do |x|
                            
                            asr = w[y][x][i]
                            eee = inarray[n][x]    #上層input
                            w[y][x][i] = asr.to_f + (@nlearn * ddd.to_f * eee.to_f)
                            
                        end
                    end
                    
                    else
                    0.upto(2) do |i| # 本層
                        
                        #計算wt和
                        sum = 0.0
                        
                        0.upto(2) do |x|    #下層
                            
                            aaa = t[y+1][x]
                            bbb = w[y+1][i][x]
                            sum = sum.to_f + (aaa.to_f * bbb.to_f)
                            
                        end
                        
                        ccc = node[n][y][i]  #本層node
                        t[y][i] = sum.to_f * ccc.to_f * (1.0 - ccc.to_f)
                        ddd = t[y][i]
                        
                        0.upto(2) do |x|
                            
                            asr = w[y][x][i]
                            eee = node[n][y-1][x]    #上層input
                            w[y][x][i] = asr.to_f + (@nlearn * ddd.to_f * eee.to_f)
                            
                        end
                    end
                end     #end if
                
            end     #end layer
        end #end case
    end
    
    
    
    0.upto(@ncaseset-1) do |n|
        0.upto(@nlayer -2) do |y|
            0.upto(2) do |i|
                node[n][y][i] = 0.0
                
            end
        end
        
        0.upto(@noutput -1) do |i|
            s[n][i] = 0.0
        end
    end
    
    puts "---------------#{time}-----------------"
    
    
end #end serror


root = TkRoot.new{title "BP ruby"}
asrinputnum = Array.new(@ninput)
infr = Nextset.frame(root)
1.upto(@ninput) do |x|
    
    TkLabel.new(infr){
        text "Input #{x} :"
        width 8
        height 1
        pack LEFT
    }
    asrinputnum[x-1] = TkVariable.new
    TkEntry.new(infr) do
        textvariable asrinputnum[x-1]
        width 3
        pack LEFT
    end
end
f = frame(root)
TkButton.new(f){
    text "Run"
    width 8
    command proc{
        
        puts "11111"
        
        asr = Nextset.runbutton(asrinputnum,w)
        Nextset.outputscan(asr)
        
    }
    pack LEFT
}

@displayText = TkLabel.new(f) {
    text "Output:"
    width 30
    height @noutput.to_i
    pack LEFT
}



end



def self.outputscan(output)

@displayText.text = "Output:"

0.upto(@noutput-1) do |o|
    
    
    a = @displayText.text
    asr = output[o]
    @displayText.text = "#{a}"+"\n#{o+1} = #{asr.to_f}"
    
    
    
    
end


end



def self.runbutton(a,w)
node = Array.new(@nlayer-1){Array.new(3)}
asr = Array.new(@noutput)

#計算每個node值
0.upto(@nlayer-1) do |y|        #layer
    
    if y == 0               #input層
        0.upto(2) do |i|        #下層
            0.upto(@ninput-1) do |x|    #上層
                
                aaa = w[y][x][i]
                bbb = node[y][i]
                node[y][i] = bbb.to_f + a[x]*aaa.to_f
                
            end
            bbb = node[y][i]
            node[y][i] = Nextset.functionchange(bbb.to_f)
        end
        elsif y == @nlayer-1    #output層
        0.upto(@noutput-1) do |i|
            0.upto(2) do |x|
                
                aaa = w[y][x][i]
                bbb = asr[i]
                ccc = node[y-1][x]
                asr[i] = bbb.to_f + ccc.to_f*aaa.to_f
                
            end
            #計算出的output
            bbb = asr[i]
            asr[i] = Nextset.functionchange(bbb.to_f)
            cccc = asr[i]
            puts "Output#{i} = #{cccc}"
        end
        else                    #隱藏層
        0.upto(2) do |i|
            0.upto(2) do |x|
                
                aaa = w[y][x][i]
                bbb = node[y][i]
                ccc = node[y-1][x]
                node[y][i] = bbb.to_f + ccc.to_f*aaa.to_f
                
            end
            #隱藏層的node值
            bbb = node[y][i]
            node[y][i] = Nextset.functionchange(bbb.to_f)
        end
    end
end

return asr
end

def self.functionchange(x)

return 1/(1+(2.71828182845905**(-1 * x.to_f)))

end

end

Main.new

Tk.mainloop
