#include <sstream>

#include <seqan3/alphabet/nucleotide/dna5.hpp>
#include <seqan3/argument_parser/all.hpp>
#include <seqan3/core/debug_stream.hpp>
#include <seqan3/io/sequence_file/all.hpp>
#include <seqan3/search/fm_index/fm_index.hpp>
#include <seqan3/search/search.hpp>

std::vector<std::vector<seqan3::dna5>> partition(std::vector<seqan3::dna5> &query, int k){
    int part_len = query.size()/(k+1);
    seqan3::debug_stream << "part len:" << part_len << "\n";
    std::vector<seqan3::dna5>::const_iterator start;
    std::vector<seqan3::dna5>::const_iterator end;
    std::vector<std::vector<seqan3::dna5>> parts(k+1);

    seqan3::debug_stream << "query: " << query << "\n";

    for (int i = 0; i < k; i++){
        start = query.begin() + part_len * i;
        end = query.begin() + part_len * (i+1);
        parts[i] = std::vector<seqan3::dna5> (start, end);
        //seqan3::debug_stream << "part " << i << ": " << parts[i] << "\n";
    }

    start = query.begin() + part_len * k;
    end = query.begin() + query.size();   //(k*part_len);
    parts[k] = std::vector<seqan3::dna5> (start, end);
    //seqan3::debug_stream << "part k+1: " << parts[k] << "\n";

    return parts;
}

int main(int argc, char const* const* argv) {
    seqan3::argument_parser parser{"fmindex_pigeon_search", argc, argv, seqan3::update_notifications::off};

    parser.info.author = "SeqAn-Team";
    parser.info.version = "1.0.0";

    
    auto reference_file = std::filesystem::path{};
    parser.add_option(reference_file, '\0', "reference", "path to the reference file");

    auto index_path = std::filesystem::path{};
    parser.add_option(index_path, '\0', "index", "path to the query file");

    auto query_file = std::filesystem::path{};
    parser.add_option(query_file, '\0', "query", "path to the query file");

    try {
         parser.parse();
    } catch (seqan3::argument_parser_error const& ext) {
        seqan3::debug_stream << "Parsing error. " << ext.what() << "\n";
        return EXIT_FAILURE;
    }

    // loading our files
    auto reference_stream = seqan3::sequence_file_input{reference_file};
    auto query_stream     = seqan3::sequence_file_input{query_file};

    // read reference into memory
    // Attention: we are concatenating all sequences into one big combined sequence
    //            this is done to simplify the implementation of suffix_arrays
    std::vector<seqan3::dna5> reference;
    for (auto& record : reference_stream) {
        auto r = record.sequence();
        reference.insert(reference.end(), r.begin(), r.end());
    }

    // read query into memory
    std::vector<std::vector<seqan3::dna5>> queries;
    for (auto& record : query_stream) {
        queries.push_back(record.sequence());
    }

    // loading fm-index into memory
    using Index = decltype(seqan3::fm_index{std::vector<std::vector<seqan3::dna5>>{}}); // Some hack
    Index index; // construct fm-index
    {
        seqan3::debug_stream << "Loading 2FM-Index ... " << std::flush;
        std::ifstream is{index_path, std::ios::binary};
        cereal::BinaryInputArchive iarchive{is};
        iarchive(index);
        seqan3::debug_stream << "done\n";
    }

    seqan3::configuration const cfg = seqan3::search_cfg::max_error_total{seqan3::search_cfg::error_count{0}};

    //!TODO here adjust the number of searches
    queries.resize(100); // will reduce the amount of searches

    //!TODO !ImplementMe use the seqan3::search to find a partial error free hit, verify the rest inside the text
    // Pseudo code (might be wrong):
    // for query in queries:
    //      parts[3] = cut_query(3, query);
    //      for p in {0, 1, 2}:
    //          for (pos in search(index, part[p]):
    //              if (verify(ref, query, pos +- ....something)):
    //                  std::cout << "found something\n"

    for (auto && q : queries){
        // partitioning the query in 3 parts
        std::vector<std::vector<seqan3::dna5>> parts = partition(q, 2); // does what it should
     
        for (auto p: parts){
            // find occurrence in index without error
            auto occ = seqan3::search(p, index, cfg);

            for (auto &&pos: occ){
                // TODO! if (verify(ref, query, pos +- ....something)):
                // std::cout << "found something\n"
            }
        }
    }

    return 0;
}