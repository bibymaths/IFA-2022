#include <sstream>
#include <chrono>

#include <filesystem>

#include <seqan3/alphabet/nucleotide/dna5.hpp>
#include <seqan3/argument_parser/all.hpp>
#include <seqan3/core/debug_stream.hpp>
#include <seqan3/io/sequence_file/all.hpp>
#include <seqan3/search/fm_index/fm_index.hpp>
#include <seqan3/search/search.hpp>

// prints out all occurences of query inside of ref
// void gibt an, dass die Funktion keinen Wert zurück gibt
// const& red heißt es gibt eine KOnstnate ref (und irgendwas mit pointer)
void findOccurences(std::vector<seqan3::dna5> const& ref, std::vector<seqan3::dna5> const& query) {
   	int count = 0;
	bool found;
   for (int i = 0; i < (int) (ref.size()-query.size()); i++){
	  found = true;
	for (int j = 0; j < (int) query.size(); j++){	
		if(ref[i+j] != query[j]){
			found = false;
		break;
	   	}
	}
	if (found == true){	
		count++;
   		seqan3::debug_stream << query << " found in reference at index " << i << "\n";
	}else{
		//seqan3::debug_stream << query << " not found.\n";
	}	
	}
}

int main(int argc, char const* const* argv) {
    seqan3::argument_parser parser{"naive_search", argc, argv, seqan3::update_notifications::off};

    parser.info.author = "SeqAn-Team";
    parser.info.version = "1.0.0";

    auto reference_file = std::filesystem::path{};
    parser.add_option(reference_file, '\0', "reference", "path to the reference file");

    auto query_file = std::filesystem::path{};
    parser.add_option(query_file, '\0', "query", "path to the query file");

    int nrQueries = 1337;
    parser.add_option(nrQueries, '\0', "queries", "number of queries");

    try {
         parser.parse();
    } catch (seqan3::argument_parser_error const& ext) {

    }


    // loading our files
    auto reference_stream = seqan3::sequence_file_input{reference_file};
    auto query_stream     = seqan3::sequence_file_input{query_file};

    // read reference into memory
    std::vector<std::vector<seqan3::dna5>> reference;
    for (auto& record : reference_stream) {
        reference.push_back(record.sequence());
    }

    // read query into memory
    std::vector<std::vector<seqan3::dna5>> queries;
    for (auto& record : query_stream) {
        queries.push_back(record.sequence());
    }

    // adjust the number of searches
    queries.resize(nrQueries); // will reduce the amount of searches

    //! search for all occurences of queries inside of reference
    // for loop: for r in reference
    
    // add timestamp
	typedef std::chrono::high_resolution_clock Time;
	typedef std::chrono::duration<float> fsec;
	auto t0 = Time::now();	

    for (auto& r : reference) {
	// for loop: for q in queries
        for (auto& q : queries) {
            findOccurences(r, q);
        }
    }

    auto t1 = Time::now();
    fsec fs = t1-t0;
    seqan3::debug_stream << fs.count() << "s\n";

    // add timestamp and compute difference then convert to seconds

    return 0;
}
