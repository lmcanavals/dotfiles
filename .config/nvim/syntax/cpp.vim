" ==============================================================================
" File:					after/syntax/cpp.vim
" Maintainer:		L M Canaval S
" Last Change:	2021-05-15
" ==============================================================================

sy keyword cppSTL abort abs accumulate acos adjacent_difference adjacent_find
sy keyword cppSTL adjacent_find_if any append asctime asin assert assign at
sy keyword cppSTL atan atan2 atexit atof atoi atol auto_ptr back back_inserter
sy keyword cppSTL bad bad_alloc bad_cast bad_exception bad_typeid badbit beg
sy keyword cppSTL begin binary_compose binary_negate binary_search bind2nd
sy keyword cppSTL binder1st binder2nd bitset bsearch c_str calloc capacity ceil
sy keyword cppSTL cerr cin clear clearerr clock clog close compare compose1
sy keyword cppSTL compose2 const_iterator construct copy copy_backward copy_n
sy keyword cppSTL cos cosh count count_if cout ctime data deque destroy
sy keyword cppSTL difference_type difftime div divides domain_error empty end
sy keyword cppSTL endl eof eofbit equal equal_range erase exception exit exp
sy keyword cppSTL fabs fail failbit failure fclose feof ferror fflush fgetc
sy keyword cppSTL fgetpos fgets fill fill_n find find_end find_first_not_of
sy keyword cppSTL find_first_of find_if find_last_not_of find_last_of first
sy keyword cppSTL flags flip floor flush fmod fopen for_each fprintf fputc
sy keyword cppSTL fputs fread free freopen frexp front fscanf fseek fsetpos
sy keyword cppSTL fstream ftell fwrite gcount generate generate_n get
sy keyword cppSTL get_temporary_buffer getc getchar getenv getline gets gmtime
sy keyword cppSTL good goodbit greater greater_equal hash_map hash_multimap
sy keyword cppSTL hash_multiset hash_set ifstream ignore in includes
sy keyword cppSTL inner_product inplace_merge insert inserter invalid_argument
sy keyword cppSTL ios ios_base iostate iota is_heap is_open is_sorted isalnum
sy keyword cppSTL isalpha iscntrl isdigit isgraph islower isprint ispunct
sy keyword cppSTL isspace istream istream_iterator istringstream isupper
sy keyword cppSTL isxdigit iter_swap iterator iterator_category key_comp ldiv
sy keyword cppSTL length length_error less less_equal lexicographical_compare
sy keyword cppSTL lexicographical_compare_3way list localtime log log10
sy keyword cppSTL logic_error logical_and logical_not logical_or longjmp
sy keyword cppSTL lower_bound make_heap malloc map max max_element max_size
sy keyword cppSTL mem_fun mem_fun1 mem_fun1_ref mem_fun_ref memchr memcpy
sy keyword cppSTL memmove memset merge min min_element minus mismatch mktime
sy keyword cppSTL modf modulus multimap multiplies multiset negate
sy keyword cppSTL next_permutation npos nth_element numeric_limits
sy keyword cppSTL ofstream open ostream ostream_iterator ostringstream
sy keyword cppSTL out_of_range overflow_error pair partial_sort
sy keyword cppSTL partial_sort_copy partial_sum partition peek perror plus
sy keyword cppSTL pointer pointer_to_binary_function pointer_to_unary_function
sy keyword cppSTL pop pop_back pop_front pop_heap pow power precision
sy keyword cppSTL prev_permutation printf ptr_fun push push_back push_front
sy keyword cppSTL push_heap put putback putc putchar puts qsort raise rand
sy keyword cppSTL random_sample random_sample_n random_shuffle range_error
sy keyword cppSTL rbegin rdbuf rdstate read realloc reference remove
sy keyword cppSTL remove_copy remove_copy_if remove_if rename rend replace
sy keyword cppSTL replace_copy replace_copy_if replace_if reserve reset resize
sy keyword cppSTL return_temporary_buffer reverse reverse_copy reverse_iterator
sy keyword cppSTL rewind rfind rotate rotate_copy runtime_error scanf search
sy keyword cppSTL search_n second seekg seekp set set_difference
sy keyword cppSTL set_intersection set_symmetric_difference set_union setbuf
sy keyword cppSTL setf setjmp setlocale setvbuf signal sin sinh size size_t
sy keyword cppSTL size_type sort sort_heap splice sprintf sqrt srand sscanf
sy keyword cppSTL stable_partition stable_sort std str strcat strchr strcmp
sy keyword cppSTL strcoll strcpy strcspn strerror strftime string strlen
sy keyword cppSTL strncat strncmp strncpy strpbrk strrchr strspn strstr strtod
sy keyword cppSTL strtok strtol strtoul strxfrm substr swap swap_ranges
sy keyword cppSTL sync_with_stdio system tan tanh tellg tellp temporary_buffer
sy keyword cppSTL test time time_t tmpfile tmpnam to_string to_ulong tolower
sy keyword cppSTL top toupper transform unary_compose unary_negate
sy keyword cppSTL underflow_error unget ungetc uninitialized_copy
sy keyword cppSTL uninitialized_copy_n uninitialized_fill uninitialized_fill_n
sy keyword cppSTL unique unique_copy unsetf upper_bound va_arg value_comp
sy keyword cppSTL value_type vector vfprintf vprintf vsprintf width write

sy keyword cppNumber NPOS

" Some openGL stuff and stuff I use because rust types are cool
sy keyword cppType     f32 f64 i8 i16 i32 i64 u8 u16 u32 u64
sy keyword cppSTL      glm vec2 vec3 vec4 mat2 mat3 mat4
sy match   cppConstant "\<\([A-Z_][A-Z0-9_]*\)\>"

hi def link cppSTL Identifier

" vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab

