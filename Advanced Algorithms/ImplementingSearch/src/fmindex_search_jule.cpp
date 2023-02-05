#include <sstream>

#include <seqan3/std/filesystem>

#include <seqan3/alphabet/nucleotide/dna5.hpp>
#include <seqan3/argument_parser/all.hpp>
#include <seqan3/core/debug_stream.hpp>
#include <seqan3/io/sequence_file/all.hpp>
#include <seqan3/search/fm_index/fm_index.hpp>
#include <seqan3/search/search.hpp>

int main(int argc, char const* const* argv) {
    typedef std::chrono:: high_resolution_clock Time;
    typedef std::chrono::milliseconds ms;
    typedef std::chrono::duration<float> fsec;
    auto t0=Time::now();

    seqan3::argument_parser parser{"fmindex_search", argc, argv, seqan3::update_notifications::off};

    parser.info.author = "SeqAn-Team";
    parser.info.version = "1.0.0";

    auto index_path = std::filesystem::path{};
    parser.add_option(index_path, '\0', "index", "path to the query file");

    auto query_file = std::filesystem::path{};
    parser.add_option(query_file, '\0', "query", "path to the query file");

    int nrQueries = 1337;
    parser.add_option(nrQueries, '\0', "queries", "number of queries");

    int nrErrors = 0;
    parser.add_option(nrErrors, '\0', "errors", "number of errors");

    try {
         parser.parse();
    } catch (seqan3::argument_parser_error const& ext) {
        seqan3::debug_stream << "Parsing error. " << ext.what() << "\n";
        return EXIT_FAILURE;
    }

    // loading our files
    auto query_stream     = seqan3::sequence_file_input{query_file};

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

    seqan3::configuration const cfg = seqan3::search_cfg::max_error_total{seqan3::search_cfg::error_count{nrErrors}};

    //!TODO here adjust the number of searches

    // extend number of queries to nrQueries if needed
	auto original_query_count = queries.size();
	while (queries.size() < nrQueries) {
		queries.push_back(queries[original_query_count-1]);
	}
	// limit the amount of searches
    queries.resize(nrQueries);

    //!TODO !ImplementMe use the seqan3::search function to search
    auto results = seqan3::search(queries, index, cfg);


    //seqan3::debug_stream << "Time taken by function: " << d.count() << "ms\n";

    
    seqan3::search_result<long unsigned int, seqan3::detail::empty_type, long unsigned int, long unsigned int> last;
    for (auto && result : results){
        last = result;
    }
    seqan3::debug_stream << last << '\n';
    //seqan3::debug_stream << result << '\n';

    
    auto t1 = Time::now();
    fsec fs = t1 -t0;
    ms d = std::chrono::duration_cast<ms>(fs);
    
    seqan3::debug_stream << "Time taken by function: " << fs.count() << "s\n";

    return 0;
}
