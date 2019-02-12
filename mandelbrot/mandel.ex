defmodule Mandel do

    # interface functions
    def mandelbrot( width, height, x, y, k, depth ) do
        trans = fn(w, h) ->
            Cmplx.new( x + k * (w - 1), y - k * (h - 1) )
        end

        rows( width, height, trans, depth, [] )
    end

    # returns a list of rows where each row is a list of colors
    # reached end of height, return list for whole picture
    def rows( _, 0, _, _, list) do
        list
    end
    def rows( width, height, trans_fnc, depth, list ) do
        this_row = row( width, height, trans_fnc, depth, [])
        rows( width, height-1, trans_fnc, depth, [this_row | list] )
    end

    # calculates a singular row
    # reached end of width, return list for this row
    def row( 0, _, _, _, list ) do
        list
    end
    def row( width, height, trans_fnc, depth, list ) do
        pixdepth = Brot.mandelbrot( trans_fnc.( width, height ), depth ) 
        color = Color.convert( pixdepth, depth )

        row( width-1, height, trans_fnc, depth, [color | list] )
    end

end # end of Mandel module
