seqan3_benchmark (global_affine_alignment_banded_simd_benchmark.cpp)
seqan3_benchmark (global_affine_alignment_benchmark.cpp)
seqan3_benchmark (global_affine_alignment_parallel_benchmark.cpp)
seqan3_benchmark (global_affine_alignment_protein_simd_benchmark.cpp)
seqan3_benchmark (global_affine_alignment_simd_benchmark.cpp)
seqan3_benchmark (local_affine_alignment_benchmark.cpp)
seqan3_benchmark (edit_distance_unbanded_benchmark.cpp)

find_package (OpenMP)

if (TARGET OpenMP::OpenMP_CXX)
    target_link_libraries (global_affine_alignment_parallel_benchmark OpenMP::OpenMP_CXX)
endif ()
