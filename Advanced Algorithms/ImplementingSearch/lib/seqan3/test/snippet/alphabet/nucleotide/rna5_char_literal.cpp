// generated from test/snippet/alphabet/nucleotide/@target_alphabet@_char_literal.cpp.in

//![main]
#include <seqan3/alphabet/nucleotide/rna5.hpp>

int main()
{
    using namespace seqan3::literals;

    seqan3::rna5 letter1{'A'_rna5};
    auto letter2 = 'A'_rna5;
}
//![main]
