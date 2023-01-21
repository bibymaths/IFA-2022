#include <divsufsort.h>
#include <sstream>
#include <filesystem>


//:#include <seqan3/std/filesystem>

#include <seqan3/alphabet/nucleotide/dna5.hpp>
#include <seqan3/argument_parser/all.hpp>
#include <seqan3/core/debug_stream.hpp>
#include <seqan3/io/sequence_file/all.hpp>
#include <seqan3/search/fm_index/fm_index.hpp>
#include <seqan3/search/search.hpp>

int main(int argc, char const* const* argv) {
    seqan3::argument_parser parser{"suffixarray_search", argc, argv, seqan3::update_notifications::off};

    parser.info.author = "SeqAn-Team";
    parser.info.version = "1.0.0";

    auto reference_file = std::filesystem::path{};
    parser.add_option(reference_file, '\0', "reference", "path to the reference file");

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

    //!TODO here adjust the number of searches
    queries.resize(100); // will reduce the amount of searches

    // Array that should hold the future suffix array
    std::vector<saidx_t> suffixarray;
    suffixarray.resize(reference.size()); // resizing the array, so it can hold the complete SA
	

    // implement suffix array sort
    // Hint, if can use libdivsufsort (already integrated in this repo)
    //      https://github.com/y-256/libdivsufsort
    //      To make the `reference` compatible with libdivsufsort you can simply
    //      cast it by calling:

    sauchar_t const* str = reinterpret_cast<sauchar_t const*>(reference.data());
	int n = reference.size(); 
	
	// start timer
	auto start = std::chrono::system_clock::now();	

	// allocate
	int *SA = (int *)malloc(n * sizeof(int));
	// compute suffix array
	divsufsort(str, SA, n);

    // search for query q in the reference ref
    for (auto& q : queries) {
        // !ImplementMe apply binary search and find q  in reference using binary search on `suffixarray`
        // You can choose if you want to use binary search based on "naive approach", "mlr-trick", "lcp"
				
		// set up variables to keep track of lower an upper bound
    	int low = 0;
		int mid = 0;
		int high = n-1;
		
		// main loop checking the current low and high bounds
		while (low < high){
			mid = (low + high) / 2;

			// get position in ref where the mid'th entry in the Suffix Array starts
			int current = SA[mid];
			// bool variable to keep track of a found match
			bool found = true;

			// loop to pair wise check letters of query and current suffix
			for (int i = 0; i < (int)q.size(); i++){
				if (reference[current + i] == q[i]){ // Case 1: q and ref align
						continue;
				}
				else if(reference[current+i] < q[i]){ // Case 2: mid is smaller than q. Adjust low
					low = mid;
					found = false;
					break;
				} else if (reference[current+i] > q[i]){ // Case 3: mid is greater than q. Adjust high
					high = mid;
					found = false;
					break;
				}
			}
			if (found == true){
				seqan3::debug_stream << q << " found at index:" << current << " in the reference.\n";
				low = high;
			}else if (high == low+1){
				seqan3::debug_stream << q << " not found.\n";
				low = high;
			}
		}	
    }

	// end timer
	auto end = std::chrono::system_clock::now();
	auto elapsed = end - start;
	std::cout << elapsed.count()/1000000000.0 << "s \n";
	// deallocate
	free(SA);

    return 0;
}
