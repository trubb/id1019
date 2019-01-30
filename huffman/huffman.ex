defmodule Huffman do

    def sample do
        'the quick brown fox jumps over the lazy dog this is a sample text that we will use when we build up a table we will only handle lower case letters and no punctuation symbols the frequency will of course not represent english but it is probably not that far off'
    end

    def text() do
        'this is something that we should encode'
    end

    def loltree() do
        [
            {106, [1,0,1,1,0,0,0,0]},
            {107, [1,0,0,0,1,1,0,0]},
            {122, [1,0,0,0,1,1,0,1]},
            {118, [1,0,1,1,0,0,0,1]},
            {120, [1,0,0,0,1,1,1]},
            {113, [1,0,1,1,0,0,1]},
            {98,  [1,0,0,0,0]},
            {97,  [0,1,0,0]},
            {115, [0,1,1,1]},
            {110, [0,1,0,1]},
            {32,  [0, 0]},
            {101, [1,1,1,0]},
            {112, [1,1,1,1,0,1]},
            {102, [1,1,1,1,0,0]},
            {105, [1,1,1,1,1]},
            {116, [1,1,0,1]},
            {114, [1,0,1,0,1]},
            {117, [1,1,0,0,1]},
            {121, [1,0,1,1,0,1]},
            {99,  [1,1,0,0,0,0]},
            {119, [1,0,1,1,1]},
            {104, [1,0,1,0,0]},
            {109, [1,1,0,0,0,1,1]},
            {103, [1,1,0,0,0,1,0]},
            {100, [1,0,0,0,1,0]},
            {108, [1, 0, 0, 1]},
            {111, [0,1,1,0]}
        ]
    end

    # assign variables
    def test do
        sample = sample()                   # assign sample
        tree = tree( sample )               # generate tree
        encode_var = loltree() #encode_table( tree )   # encode the tree
        decode_var = loltree() #decode_table( tree )   # decode the tree
        text = text()                       # assign text
        seq = encode( text, encode_var )    # encode text
        decode( seq, decode_var )           # decode text
#IO.puts inspect()
    end

###############################################################################
    # generate a tree from the sample
    # returns a trees
    def tree( sample ) do
        freq = freq( sample )
        huffman( freq )
    end

    # base where we're passed a sample text
    # reply with sample text and empty list?????
    def freq( sample ) do
        freq( sample, [] )
    end
    # passed empty sample
    def freq( [], frequencylist ) do
        List.keysort( frequencylist, 1 )
    end
    # passed matching list + frequency
    def freq( [ char | rest ], frequencylist ) do
        # frequency is a list 
        frequencylist = addtofreq( char, frequencylist )
        # anropa samma funktion med <sample text> och listan med frekvenstupler
        freq( rest, frequencylist )
    end

    # representera frekvens som tupler innehållande
    # tecken och antal förekomster
    # passed a char and empty list
    def addtofreq( char, [] ) do
        [ { char, 1 } ]
    end
    # passed a char and a list
    # checks list if the char appears in it???
    # and increments occurence in the tuple
    def addtofreq( char, [ { char, occurence } | rest ] ) do
        [ { char, occurence + 1 } | rest ]
    end
    # passed a char and a list
    def addtofreq( char, [ { otherchar, occurence } | rest ] ) do
        [ { otherchar, occurence } | addtofreq( char, rest ) ]
    end

    def huffman( frequencylist ) do
        tuple_maker( frequencylist )
    end

    # TODO THIS IS BROKEN SOMEHOW????

    def tuple_maker( [] ) do
        []
    end

    # TODO - consider changing "char_X" to "item_X" to  be more clear
    def tuple_maker( [ { char_a, f_a } | [] ] ) do
        { char_a, f_a }
    end

    # might have to be the tuples a & b containing (char, value)
    # or just do the character from each of the passed tuples
    # probably not necessary to keep the occurence values in the leaves tbh
    # since we're just gonna go walking in the tree, not check occurences
    def tuple_maker( [ { char_a, f_a }, { char_b, f_b } | tail ] ) do
        tuple_maker(
            List.keysort( [ { { {char_a, f_a}, {char_b, f_b} }, f_a + f_b } | tail ], 1 )
        )
    end

###############################################################################
    # generate a encoding table from the tree
    # letters -> prefix-free binary code?
    def encode_table( tree ) do
        travtree( tree )
    end

    # traverse the tree to find leaves
    def travtree( { {left,  right}, _ } ) do
        l = travtree(  left, [0] )
        r = travtree(  right, [1] )
        #[l] ++ [r]
        List.keysort( List.flatten(Enum.reverse( [l | [r]] )), 0)  #[L|[R]] is the same as above
    end

    def travtree( { {left,  right}, _value }, path ) do
        l = travtree( left, [ 0 | path ] )
        r = travtree( right, [ 1 | path ] )
        List.flatten(Enum.reverse( [l | [r]] ))
    end

    def travtree( { char, _value }, path ) when is_integer( char ) do
        {char, path}
    end

###############################################################################
    # encode the text based on the table
    # returns a sequence of bits (a list!)
    def encode( text, table ) do
        encode( text, table, table )
    end
    def encode( [] ,_ ,_ ), do: []
    def encode( _, [], _virgintable ) do
        IO.puts("REEEEEEEEEEEEEEEEE")
    end
    def encode( [char | rest], [ { char, list } | _t], virgintable ) do
        list ++ encode( rest, virgintable )
    end
    def encode( text, [ _ | tail ], virgintable ) do
        encode( text, tail, virgintable )
    end

###############################################################################
    # generate a decoding table from the tree
    # prefix-free binary code -> letters?
    def decode_table( tree ) do
        encode_table( tree )
    end

    # decode the generated sequence based on the tree
    # returns a text
    def decode( [], _ ), do: []

    def decode( seq, encodingtable ) do
        { char, rest } = decode_char( seq, 1, encodingtable )
        [ char | decode( rest, encodingtable ) ]
    end

    def decode_char( [], _, _ ), do: []

    def decode_char( seq, n, encodingtable ) do
        { code, rest } = Enum.split( seq, n )

        # keyfind returns a tuple if it finds a match
        # searching for a code matching our code in the table
        # looking at the second position within the tuple
        case List.keyfind( encodingtable, code, 1 ) do
            { char, _ } -> # if we find a match return the tuple
                { char, rest };
            nil -> # else we gotta check a larger bit sequence
                decode_char( seq, n + 1 , encodingtable )
        end
    end

    def read( file, n ) do
        { :ok, file } = File.open( file, [ :read ] )
        binary = IO.read( file, n )
        File.close( file )

        case :unicode.characters_to_list( binary, :utf8 ) do
            { :incomplete, list, _ } ->
                list;
            list ->
                list
        end
    end

end
