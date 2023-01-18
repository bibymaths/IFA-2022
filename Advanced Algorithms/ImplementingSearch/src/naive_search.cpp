#include <sstream>

#include <seqan3/std/filesystem>

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
    //!TODO ImplementMe
    // ref hat Länge 100000000
    int occur_query = 0;
    int step_ref =0;
    for (int i = 0; i <= ref.size(); i++){
	    for(auto& q : query){
		    if (i+step_ref > ref.size()){
			    goto stop;
		    }
		    if (ref[i+step_ref]!=q){
			    goto stop;
		    }
		    step_ref ++;
		       
	    }
	    occur_query ++;
	    stop:
	    	int step_ref = 0;
	    	

    }
    std::cout << occur_query << " times";

}

int main(int argc, char const* const* argv) {
    seqan3::argument_parser parser{"naive_search", argc, argv, seqan3::update_notifications::off};

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
    std::vector<std::vector<seqan3::dna5>> reference;
    //int count=0;
    for (auto& record : reference_stream) {
        reference.push_back(record.sequence());
	//count++;

    }

    //std::cout << reference.size() << "\n" << "count: " << count << "\n";
    // reference besteht aus einem Element
    //std::cout << reference.count();
    //std::cout << reference.at(0);
	    
    

    // read query into memory:
    std::vector<std::vector<seqan3::dna5>> queries;
    //int c=0;
    for (auto& record : query_stream) {
        queries.push_back(record.sequence());
	//c++;
    }
    //std::cout << queries.size() << "\n" << "count: " << c << "\n";
    //queries besteht aus 100.000 Elementen
    //std::cout << typeid(queries);	
	

    //!TODO !CHANGEME here adjust the number of searches
    queries.resize(100); // will reduce the amount of searches

    //! search for all occurences of queries inside of reference
    // for loop: for r in reference
    typedef std::chrono:: high_resolution_clock Time;
    typedef std::chrono::milliseconds ms;
    typedef std::chrono::duration<float> fsec;
    auto t0=Time::now();
    for (auto& r : reference) {
	// for loop: for q in queries
	int number_query = 1;
        for (auto& q : queries) {
		std::cout << "query " << number_query << " occures ";
		findOccurences(r, q);
		std::cout << "\n";
		number_query ++;
        }
    }
    auto t1 = Time::now();
    fsec fs = t1 -t0;
    ms d = std::chrono::duration_cast<ms>(fs);
    
    std::cout << "Time taken by function: " << fs.count() << "s\n";
    std::cout << "Time taken by function: " << d.count() << "ms\n";


    return 0;
}
