// generated from test/snippet/alphabet/nucleotide/@target_alphabet@_char_literal.cpp.in

//![main]
#include <seqan3/alphabet/nucleotide/rna4.hpp>

int main()
{
    using namespace seqan3::literals;

    seqan3::rna4 letter1{'A'_rna4};
    auto letter2 = 'A'_rna4;
}
//![main]
