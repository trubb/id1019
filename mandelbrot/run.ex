defmodule Run do

#    def demo() do
#        small(-2.6, 1.2, 1.2, 256)
#    end

    def d(x, y, k, width, height, depth) do
        small( x, y, k, width, height, depth)
    end

    # x0 = 
    # y0 = 
    # xn = 
    def small(x0, y0, xn, width, height, depth) do
        #width = 1920
        #height = 1080
        k = ( xn - x0 ) / width
        image = Mandel.mandelbrot( width, height, x0, y0, k, depth )
        PPM.write("small.ppm", image)
    end
end