// -----------------------------------------------------------------------------------------------------
// Copyright (c) 2006-2022, Knut Reinert & Freie Universität Berlin
// Copyright (c) 2016-2022, Knut Reinert & MPI für molekulare Genetik
// This file may be used, modified and/or redistributed under the terms of the 3-clause BSD-License
// shipped with this file and also available at: https://github.com/seqan/seqan3/blob/master/LICENSE.md
// -----------------------------------------------------------------------------------------------------

/*!\file
 * \author Svenja Mehringer <svenja.mehringer AT fu-berlin.de>
 * \brief  Provides the seqan3::views::repeat.
 */

#pragma once

#include <algorithm>
#include <ranges>

#include <seqan3/core/detail/iterator_traits.hpp>
#include <seqan3/core/range/detail/random_access_iterator.hpp>
#include <seqan3/core/range/type_traits.hpp>

namespace seqan3::detail
{

// ---------------------------------------------------------------------------------------------------------------------
// repeat_view class
// ---------------------------------------------------------------------------------------------------------------------

/*!\brief The type returned by seqan3::views::repeat.
 * \tparam value_t The type of value to repeat which is always wrapped in a std::views::single.
 * \implements std::ranges::view
 * \implements std::ranges::random_access_range
 * \implements std::ranges::output_range
 * \ingroup utility_views
 *
 * \details
 *
 * This class models an infinite range over a given value, although "infinity" is limited by the maximum value of
 * `difference_type` of which the iterator stores a member variable to represent distances.
 *
 * Note that most members of this class are generated by std::ranges::view_interface which is not yet documented here.
 */
template <std::copy_constructible value_t>
class repeat_view : public std::ranges::view_interface<repeat_view<value_t>>
{
private:
    //!/brief the base type.
    using base_t = std::ranges::view_interface<repeat_view<value_t>>;

    //!\brief The sentinel type is set to std::default_sentinel_t.
    using sentinel_type = std::default_sentinel_t;

    //!\brief The view which wraps the single value to repeat.
    using single_value_t = decltype(std::views::single(std::declval<value_t>()));

    /*!\name Associated types
     * These associated types are needed in seqan3::detail::random_access_iterator.
     * \{
     */
    //!\brief The value type (equals the value_t with any references removed).
    using value_type = std::remove_reference_t<value_t>;
    //!\brief The reference_type.
    using reference = value_type &;
    //!\brief The const reference type.
    using const_reference = value_type const &;
    //!\brief The type to store the difference of two iterators.
    using difference_type = ptrdiff_t;
    //!\}

    //!\brief The forward declared iterator type for views::repeat (a random access iterator).
    template <typename parent_type>
    class basic_iterator;

    /*!\name Associated types
    * \{
    */
    //!\brief The iterator type of this view (a random access iterator).
    using iterator = basic_iterator<repeat_view>;
    //!\brief The const_iterator type is equal to the iterator type but over the const qualified type.
    using const_iterator = basic_iterator<repeat_view const>;
    //!\}

    //!\brief Befriend the following class s.t. iterator and const_iterator can be defined for this type.
    template <typename parent_type, typename crtp_base>
    friend class detail::random_access_iterator_base;

public:
    /*!\name Constructors, destructor and assignment
     * \{
     */
    repeat_view() = default;                                //!< Defaulted.
    repeat_view(repeat_view const &) = default;             //!< Defaulted.
    repeat_view & operator=(repeat_view const &) = default; //!< Defaulted.
    repeat_view(repeat_view &&) = default;                  //!< Defaulted.
    repeat_view & operator=(repeat_view &&) = default;      //!< Defaulted.
    ~repeat_view() = default;                               //!< Defaulted.

    //!\brief Construct from any type (Note: the value will be copied into views::single).
    constexpr explicit repeat_view(value_t const & value) : single_value{value}
    {}

    //!\overload
    constexpr explicit repeat_view(value_t && value) : single_value{std::move(value)}
    {}
    //!\}

    /*!\name Iterators
     * \{
     */
    /*!\brief Returns an iterator to the first element of the range.
     * \returns Iterator to the first element.
     *
     * \details
     *
     * This range is never empty so the returned iterator will never be equal to end().
     *
     * ### Complexity
     *
     * Constant.
     *
     * ### Exceptions
     *
     * No-throw guarantee.
     */
    constexpr iterator begin() noexcept
    {
        return iterator{*this};
    }

    //!\copydoc begin()
    constexpr const_iterator begin() const noexcept
    {
        return const_iterator{*this};
    }

    /*!\brief Returns an iterator to the element following the last element of the range.
     * \returns Iterator to the end.
     *
     * \details
     *
     * This element acts as a placeholder; attempting to dereference it results in undefined behaviour.
     *
     * ### Complexity
     *
     * Constant.
     *
     * ### Exceptions
     *
     * No-throw guarantee.
     */
    constexpr sentinel_type end() noexcept
    {
        return {};
    }

    //!\copydoc end()
    constexpr sentinel_type end() const noexcept
    {
        return {};
    }
    //!\}

    /*!\name Element access
     * \{
     */
    /*!\brief Returns the n-th element.
     * \param n The position of the element to return.
     * \returns A reference to the cached value.
     *
     * \details
     *
     * Since this range is an infinite range, access is never out-of-bounds.
     *
     * ### Complexity
     *
     * Constant.
     *
     * ### Exceptions
     *
     * No-throw guarantee.
     */
    constexpr const_reference operator[](difference_type const SEQAN3_DOXYGEN_ONLY(n)) const noexcept
    {
        return *single_value.begin();
    }

    //!\copydoc operator[]()
    constexpr reference operator[](difference_type const SEQAN3_DOXYGEN_ONLY(n)) noexcept
    {
        return *single_value.begin();
    }
    //!}

private:
    //!\brief A std::views::single over the input.
    single_value_t single_value;
};

//!\brief The iterator type for views::repeat (a random access iterator).
template <std::copy_constructible value_t>
template <typename parent_type>
class repeat_view<value_t>::basic_iterator : public detail::random_access_iterator_base<parent_type, basic_iterator>
{
    //!\brief The CRTP base type.
    using base_t = detail::random_access_iterator_base<parent_type, basic_iterator>;

    //!\brief The base position type.
    using typename base_t::position_type;

public:
    //!\brief Type for distances between iterators.
    using typename base_t::difference_type;
    //!\brief Value type of container elements.
    using typename base_t::value_type;
    //!\brief Use reference type defined by container.
    using typename base_t::reference;
    //!\brief Pointer type is pointer of container element type.
    using typename base_t::pointer;
    //!\brief Tag this class as a random access iterator.
    using typename base_t::iterator_category;

    /*!\name Constructors, destructor and assignment
     * \{
     */
    basic_iterator() = default;                                   //!< Defaulted.
    basic_iterator(basic_iterator const &) = default;             //!< Defaulted.
    basic_iterator & operator=(basic_iterator const &) = default; //!< Defaulted.
    basic_iterator(basic_iterator &&) = default;                  //!< Defaulted.
    basic_iterator & operator=(basic_iterator &&) = default;      //!< Defaulted.
    ~basic_iterator() = default;                                  //!< Defaulted.

    /*!\brief Construct by host range.
     * \param host The host range.
     */
    explicit constexpr basic_iterator(parent_type & host) noexcept : base_t{host}
    {}

    /*!\brief Constructor for const version from non-const version.
     * \param rhs a non-const version of basic_iterator to construct from.
     */
    template <typename parent_type2>
        requires std::is_const_v<parent_type>
              && (!std::is_const_v<parent_type2>) && std::is_same_v<std::remove_const_t<parent_type>, parent_type2>
    constexpr basic_iterator(basic_iterator<parent_type2> const & rhs) noexcept : base_t{rhs}
    {}
    //!\}

    /*!\name Comparison operators
     * \{
     */
    //!\brief Inherit the equality comparison (same type) from base type.
    using base_t::operator==;
    //!\brief Inherit the inequality comparison (same type) from base type.
    using base_t::operator!=;

    //!\brief Equality comparison to the sentinel always returns false on an infinite view.
    constexpr bool operator==(std::default_sentinel_t const &) const noexcept
    {
        return false;
    }

    //!\brief Inequality comparison to the sentinel always returns true on an infinite view.
    constexpr bool operator!=(std::default_sentinel_t const &) const noexcept
    {
        return true;
    }

    //!\brief Equality comparison to the sentinel always returns false on an infinite view.
    friend constexpr bool operator==(std::default_sentinel_t const &, basic_iterator const &) noexcept
    {
        return false;
    }

    //!\brief Inequality comparison to the sentinel always returns true on an infinite view.
    friend constexpr bool operator!=(std::default_sentinel_t const &, basic_iterator const &) noexcept
    {
        return true;
    }
    //!\}
};

// ---------------------------------------------------------------------------------------------------------------------
// repeat (factory)
// ---------------------------------------------------------------------------------------------------------------------

//!\brief View factory definition for views::repeat.
struct repeat_fn
{
    //!\brief Returns an instance of seqan3::detail::repeat_view constructed with \p value.
    template <std::copy_constructible value_type>
    constexpr auto operator()(value_type && value) const
    {
        return detail::repeat_view{std::forward<value_type>(value)};
    }
};

} // namespace seqan3::detail

namespace seqan3::views
{
/*!\brief A view factory that repeats a given value infinitely.
 * \tparam    value_t  The type of value to repeat wrapped in a std::views::single; must model std::copy_constructible.
 * \param[in] value    The value to repeat.
 * \returns An infinite range over value.
 * \ingroup utility_views
 *
 * \details
 *
 * \header_file{seqan3/utility/views/repeat.hpp}
 *
 * ### View properties
 *
 * This view is **source-only**, it can only be at the beginning of a pipe of range transformations.
 *
 * | Concepts and traits              | `rrng_t` (returned range type)                     |
 * |----------------------------------|:--------------------------------------------------:|
 * | std::ranges::input_range         | *guaranteed*                                       |
 * | std::ranges::forward_range       | *guaranteed*                                       |
 * | std::ranges::bidirectional_range | *guaranteed*                                       |
 * | std::ranges::random_access_range | *guaranteed*                                       |
 * | std::ranges::contiguous_range    |                                                    |
 * |                                  |                                                    |
 * | std::ranges::viewable_range      | *guaranteed*                                       |
 * | std::ranges::view                | *guaranteed*                                       |
 * | std::ranges::sized_range         |                                                    |
 * | std::ranges::common_range        |                                                    |
 * | std::ranges::output_range        | *guaranteed*                                       |
 * | seqan3::const_iterable_range     | *guaranteed*                                       |
 * |                                  |                                                    |
 * | std::ranges::range_reference_t   | std::remove_reference_t<value_t> &                 |
 *
 * See the \link views views submodule documentation \endlink for detailed descriptions of the view properties.
 *
 * \attention The given value to repeat is always **copied** into the range.
 *
 * ### Example
 *
 * \include test/snippet/utility/views/repeat.cpp
 *
 * \hideinitializer
 */
inline constexpr detail::repeat_fn repeat{};

} // namespace seqan3::views
