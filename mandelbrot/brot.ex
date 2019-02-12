defmodule Brot do

    # return i, if abs(zi) > 0
    # else return 0
    # always return a value in the range 0..(m-1)
    def mandelbrot( complex, miterations ) do
        z0 = Cmplx.new( 0, 0 )
        i = 0
        test( i, z0, complex, miterations )
    end

    # max iterations allowed has been reached
    # return i, i = m
    def test( m, _, _, m ) do
        0
    end

    def test( i, z, c, m ) do
        cond do
            Cmplx.abs( z ) > 2 ->
                i # if the absolute value is above 2
            true ->
                nextz = Cmplx.add( Cmplx.sqr(z), c )
                test( i+1, nextz, c, m )
        end
    end

end # end of Brot module
