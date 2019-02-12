defmodule Cmplx do
    
    # returns the complex number with real and imaginary values
    def new( real, imaginary ) do
        { real, imaginary }
    end

    # adds two complex numbers
    def add( { ar, ai }, { br, bi } ) do
        { ar + br, ai + bi }
    end

    # squares a complex number
    def sqr( { ar, ai } ) do
        { ( ar * ar ) - ( ai * ai ), 2 * ar * ai }
    end

    # returns the absolute value of a number
    def abs( {ar, ai} ) do
        :math.sqrt( ( ar * ar ) + ( ai * ai ) )
    end

end # end of Cmplx module
