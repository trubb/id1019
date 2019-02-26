defmodule Color do
    
    # takes in depth on a scale [0 - max]
    # returns a generated color
    def convert( depth, max ) do
        f = depth / max
        a = f*4
        x = trunc( a )
        y = trunc( 255 * (a - x) )

        case x do
            0 ->
                {:rgb,y,10,10}
                #{:rgb,y,0,0}
            1 ->
                {:rgb,122,y,105}
                #{:rgb,255,y,0}
            2 ->
                {:rgb,255-y,144,62}
                #{:rgb,255-y,255,0}
            3 ->
                {:rgb,0,234,y}
                #{:rgb,0,255,y}
            4 ->
                {:rgb,100,255-y,107}
                #{:rgb,0,255-y,255}
        end
    end

end # end of Color module
